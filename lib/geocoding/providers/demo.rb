# Demo provider returns known locations from memory for testing purposes.
# 
require "geocoder"

module Geocoding
  module Providers
    class Demo
      def initialize
        @results = {
          "chicago" => Geocoding::Entry.new(
            id: "demo_chicago",
            display_name: "Chicago, IL",
            city: "Chicago",
            state: "IL",
            country: "US",
            zipcode: "60600",
            lat: "41.8755616",
            lon: "-87.6244212"
          ),
          "new york" => Geocoding::Entry.new(
            id: "demo_new_york",
            display_name: "New York, NY",
            city: "New York",
            state: "NY",
            country: "US",
            zipcode: "10001",
            lat: "40.7127281",
            lon: "-74.0060152"
          )
        }
      end

      def lookup(query)
        @results[query.strip.downcase]
      end
    end
  end
end
