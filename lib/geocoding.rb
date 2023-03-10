# Geocoding module allows us to easily look up geo coordinates for an address or a zip code.
# We're supporting a few different implementations, powered by Geocoder, OpenWeather and
# a static one, returning data for specific lookup keys.
#
require "geocoding/providers/default"
require "geocoding/providers/demo"
require "geocoding/providers/open_weather"

module Geocoding
  @@provider = Geocoding::Providers::Default.new

  class << self
    # Returns the current provider class
    def provider
      @@provider
    end

    # Sets a new provider class
    def provider=(val)
      @@provider = val.is_a?(Symbol) ? provider_for_name(val).new : val
    end

    # Returns a provider class for a given name
    def provider_for_name(name)
      case name
      when :default
        Geocoding::Providers::Default
      when :demo
        Geocoding::Providers::Demo
      when :open_weather
        Geocoding::Providers::OpenWeather
      else
        raise ArgumentError, "invalid provider name: #{name}"
      end
    end
  end
end
