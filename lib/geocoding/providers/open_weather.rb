# OpenWeather provider uses Open Weather geolocation API service client

module Geocoding
  module Providers
    class OpenWeather
      def initialize
        @client = ::OpenWeather::Geo::Client.new
      end

      def lookup(query)
        result = geocode(query)
        result = result.first if result.is_a?(Array)
        result ? format_entry(result) : nil
      end

      private

      def geocode(input)
        case input
        when /^[\d]{5}$/
          @client.zipcode(input)
        else
          @client.address(input)
        end
      end

      def format_entry(result)
        Geocoding::Entry.new(
          display_name: result["name"],
          city:         result["name"],
          country:      result["country"],
          zipcode:      result["zip"],
          lat:          result["lat"],
          lon:          result["lon"]
        )
      end
    end
  end
end
