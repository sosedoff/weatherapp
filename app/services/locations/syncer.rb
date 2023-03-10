module Locations
  class Syncer
    include DataMapper

    InvalidDataError = Class.new(StandardError)

    def initialize(location)
      @location   = location
      @forecaster = ForecastService.new(@location)
    end

    def sync
      # Find existing weather point for this location
      @current = @location.weather_point || WeatherPoint.new(location_id: @location.id)

      # Fetch data from the external service (the data would be cached for some time)
      update_attributes(@forecaster.fetch_current)
      unless @current.external_id
        raise InvalidDataError, "point does not provide external ID"
      end

      # Flush the cached weather point
      Cache.delete("current", @location.id)

      # Update the last sync status if there were no changes in weather
      if @current.persisted? && !@current.changed.include?("ts")
        return update_sync_status
      end

      save_changes
    end

    private

    def save_changes
      ActiveRecord::Base.connection.transaction do
        update_sync_status if @current.save
      end
    end

    def update_sync_status
      @location.update(
        utc_offset: @current.utc_offset,
        weather_point_id: @current.id,
        last_sync_at: Time.current
      )
    end

    def update_attributes(data)
      @current.assign_attributes(weather_point_attributes(data))
    end
  end
end
