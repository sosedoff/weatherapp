# Default provider uses "geocoder" gem to fetch geograph data for a given query
require "geocoder"

module Geocoding
  module Providers
    class Default
      def lookup(query)
        result = Geocoder.search(query, params: { countrycodes: "us" })&.first
        result ? format_entry(result.data) : nil
      end

      private

      def format_entry(data)
        addr = data["address"]

        Geocoding::Entry.new(
          id:           data["place_id"],
          display_name: data["display_name"],
          city:         addr["city"] || addr["town"] || addr["hamlet"],
          state:        addr["state"],
          country:      addr["country"],
          lat:          data["lat"].to_f,
          lon:          data["lon"].to_f
        )
      end
    end
  end
end
