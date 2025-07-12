# OpenWeather provider uses Open Weather geolocation API service client

module Geocoding
  module Providers
    class OpenWeather
      def initialize
        @client = ::OpenWeather::Geo::Client.new
      end

      def lookup(query)
        raise "!!!!"
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
        # Create a unique ID based on coordinates and name
        unique_id = "ow_#{result['lat']}_#{result['lon']}_#{result['name']}".gsub(/[^a-zA-Z0-9_]/, '_')
        
        Geocoding::Entry.new(
          id: unique_id,
          display_name: result["name"],
          city: result["name"],
          state: result["state"] || "Unknown",
          country: result["country"],
          zipcode: result["zip"],
          lat: result["lat"],
          lon: result["lon"]
        )
      end
    end
  end
end
