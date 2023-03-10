class ScheduledSyncJob < ApplicationJob
  def perform
    # Find all locations with outdated weather data and schedule sync with the forecasting service.
    #
    # Forecasting data is cached, so running the same sync job for each location will be
    # fast and will skip data updates if no changes were detected.
    #
    Location.stale.find_each(batch_size: 100) do |location|
      location.schedule_sync
    end
  end
end
