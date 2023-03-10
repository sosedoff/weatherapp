# Locations importer service handles creation of the Location objects in the database

module Locations
  class Importer
    def initialize(entry)
      # Geocoding entries must have all provide an external service ID
      raise ArgumentError, "entry.id value is required" unless entry.id
      @entry = entry
    end

    def import
      # Find the location for a given geocoding entry
      location = Location.find_by(external_id: @entry.id)
      return location if location

      # Import the location
      location = create_location

      # Schedule initial forecast data syncs
      if location.persisted?
        location.schedule_sync
      end

      location
    end

    private

    def create_location
      Location.create(
        external_id: @entry.id,
        city:        @entry.city,
        state:       @entry.state,
        country:     @entry.country,
        zipcode:     @entry.zipcode,
        lat:         @entry.lat,
        lon:         @entry.lon
      )
    end
  end
end
