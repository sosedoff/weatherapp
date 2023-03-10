# HTTP client library
require "faraday"
require "forwardable"

# Core classes
require "open_weather/config"
require "open_weather/endpoints"
require "open_weather/base"
require "open_weather/client"

# Service clients
require "open_weather/forecast/client"
require "open_weather/geo/client"

# Global Configuration
module OpenWeather
  @config = Config.new

  class << self
    extend Forwardable

    def_delegators :@config, :api_key, :api_key=
    def_delegators :@config, :debug, :debug=
    def_delegators :@config, :units, :units=
    def_delegators :@config, :language, :language=

    def configure
      yield @config
    end
  end
end

# Piece of code above allows us to configure OpenWeather globally:
#
# require "open_weather"
#
# OpenWeather.api_key = "foobar"
# OpenWeather.debug = true
#
# or using the configuration block:
#
# OpenWeather.configure do |cfg|
#  cfg.api_key = "..."
# end
#
