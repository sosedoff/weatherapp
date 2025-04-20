require "open_weather"

# Configure a different OpenWeather API key if OPENWEATHER_API_KEY env var is not set
OpenWeather.api_key = ENV["OPENWEATHER_API_KEY"]

# Configure debug logging of requests
OpenWeather.debug = true

# Using configuration block to set common settings
OpenWeather.configure do |cfg|
  cfg.units = ENV.fetch("OPENWEATHER_UNITS", "imperial")
  cfg.language = "en"
end
