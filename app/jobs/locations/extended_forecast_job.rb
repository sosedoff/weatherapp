# This job updates the extended forecast for 5 days for the given location

module Locations
  class ExtendedForecastJob < BaseSyncJob
    def perform(location_id)
      location = Location.find(location_id)
      LocationService.sync_extended(location)
    end
  end
end
