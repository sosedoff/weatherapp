# Application Overview

This is a demo weather application to query and display Weather information from third
party service based on the input city, zipcode or an address.

We're using [Open Weather API](https://openweathermap.org/api) for current and forecast
weather. [Geocoder](http://www.rubygeocoder.com/) gem is used to translate location
search query into the coordinates, since Weather services cannot provide data solely
based on the city name or an address.

Application is split into 2 systems: Web application to display data, and Worker application
to perform background jobs. Fetching weather data (and updating the existing one) is
done via Sidekiq jobs.

## Flow

1. Application does not include any locations by default, so user must search for a city or a zipcode.
2. City (or zipcode) is entered into the search box on the home page
3. We then attempt to geocode the query (via sync call) to determine geo coordinates and location info (city,state,etc). All query lookups are cached for 24 hours (including invalid ones).
4. If query is geocoded, we're creating a new `Location` record that references the third party data (via `external_id`) and store all necessary attributes.
   4.1. Skip if location already exists.
   4.2. If location is missing any required data, we let user know that query was invalid.
   4.3. Kick off weather data sync via `CurrentForecastJob` jobs.
5. We redirect user to the weather page for the specific location.
   5.1. If location weather has not been synced, we display loading screen while the background job is working.
   5.2. We automatically refresh the page every 2 seconds (UX could be improved here) until we know when the weather data is available.
   5.3. Page is reloaded and displaying the most recent weather information along with the extended forecast.
6. When location already exists, we just try to pull what we have in cache/DB and display the information.
7. Every minute the background job is kicked off and will periodically update current/forecasted weather for locations in the system (only when necessary)

NOTE: We could safely drop the entire cache (in Redis) and the application can still dislay
the most recent weather information (excluding the extended forecast).

## Structure

### Services

We're using basic Services pattern for most of the functionality to keep models,
controller and jobs lean.

High level:

- `app/services/geocoder_service.rb` - Provides geocoding data based on the input query.
- `app/services/forecast_service.rb` - Fetches current and extended weather data form API.
- `app/services/location_service.rb` - Wrapper for Location services (see below).

Locations:

- `app/services/locations/importer.rb` - Manages creating/syncing `Location` records in the database.
- `app/services/locations/data_mapper.rb` - Provides data mapping from OpenWeather client to `WeatherPoint` records, used for current weather and for extended forecasting.
- `app/services/locations/syncer.rb` - Performs current weather data sync for `Locations`.
- `app/services/locations/extended_syncer.rb` - Perform extended forecast data sync. Does not persist anything in the database, only in cache.

### Core

Services above interact with third-party dependencies (Geocoding, Weather) via Core classes.

- `lib/cache.rb` - High level caching wrapper, used across services, jobs and controllers. Encapsulated `Rails.cache`.
- `lib/open_weather.rb` - Client library for working with OpenWeather services, provides implementation for Weather, Forcast and Geocode APIs. Globally configurable.
- `lib/geocoding.rb` - High level module to deal with Geocoding functionality in the application. Includes multiple `Provider` implementation that could be easily swapped via rails initializer based on the need.

### Jobs

Jobs handle all background processing in the application, which consists of:

- Scheduling data updates for locations with stale weather data
- Fetching current weather data for locations and persisting data points in DB/Cache
- Fetching extended forecast data and caching it without DB persistence.
