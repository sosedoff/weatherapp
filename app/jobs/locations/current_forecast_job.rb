# This job updates the current weather data for the given location

module Locations
  class CurrentForecastJob < BaseSyncJob
    def perform(location_id)
      location = Location.find(location_id)
      LocationService.sync_current(location)
    end
  end
end
