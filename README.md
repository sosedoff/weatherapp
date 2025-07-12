# Weather App

<img src="/public/screens/1.png" style="max-width:50%" />
<img src="/public/screens/2.png" style="max-width:50%" />

This is a test Ruby on Rails application to illustrate certain features of the framework, like
background jobs and custom service client development.

## Requirements

- Ruby 3.2
- PostgreSQL (for persistent storage)
- Redis (for caching and background job processing)
- OpenWeather API key (for fetching weather data). Example key is provided.

Workflow and Code overview is located in [NOTES.md](/NOTES.md)

## Installation

Clone repository and install the dependencies:

```bash
git clone https://github.com/sosedoff/weatherapp.git
cd weatherapp
bundle install
```

## Configuration

Make sure PostgreSQL and Redis are installed and running.

Next, execute the init script that will setup env vars and migrate/seed the database:

```bash
./bin/init
```

If not using the init script, first create a env config file `.env.development` by
copying the example one:

```bash
cp .env.example .env.development
```

Then prepare and seed the database:

```bash
bundle exec rails db:create db:migrate db:seed
```

## Running application

To start web and worker processes, run:

```bash
bundle exec foreman start
```

This will start the Rails process on `http://localhost:3000` and Sidekiq worker.

## Caching Data

Enable Rails caching in development:

```bash
bundle exec rails dev:cache
```

### Configuring OpenWeather Client

Make sure you have valid [OpenWeather API](https://openweathermap.org/api) key.
See `./bin/init` script for a Gist containing example key.

To configure the client, edit the `config/initializers/open_weather.rb` file:

```ruby
require "open_weather"

# Configure a different OpenWeather API key if OPENWEATHER_API_KEY env var is not set
OpenWeather.api_key = ENV["OPENWEATHER_API_KEY"]

# Configure debug logging of requests
OpenWeather.debug = true

# Using configuration block to set common settings
OpenWeather.configure do |cfg|
  cfg.units = "imperial"
  cfg.language = "en"
end
```

## Manually Updating Weather Data

You can manually update all locations with the most recent weather and forecast data using provided rake tasks or via the Rails console.

### Using Rake Tasks

First, make sure Rails caching is enabled:

```bash
bundle exec rails dev:cache
```

Then, use one of the following rake tasks:

- **Sync all locations (queues jobs for Sidekiq):**
  ```bash
  bundle exec rake locations:sync_all
  ```
- **Sync only stale locations (not updated in last 5 minutes):**
  ```bash
  bundle exec rake locations:sync_stale
  ```
- **Force sync all locations immediately (runs jobs inline):**
  ```bash
  bundle exec rake locations:force_sync_all
  ```
- **Check sync status for all locations:**
  ```bash
  bundle exec rake locations:status
  ```

### Using Rails Console

You can also trigger syncs manually for specific locations or all locations:

```bash
bundle exec rails console
```

Then, in the console:

```ruby
# Sync a specific location by ID
your_location = Location.find("your-location-id")
your_location.schedule_sync

# Sync all locations (queues jobs)
Location.find_each { |loc| loc.schedule_sync }

# Force sync a specific location immediately (runs jobs inline)
location = Location.find("your-location-id")
Locations::CurrentForecastJob.perform_now(location.id)
Locations::ExtendedForecastJob.perform_now(location.id)
```

These commands will update both the current weather and the extended forecast for the selected locations.

## Running Tests

To execute the spec suite:

```
bundle exec rspec spec/
```

## License

Application and its code is distributed under MIT License
