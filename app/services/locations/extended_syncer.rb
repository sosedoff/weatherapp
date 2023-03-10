# ExtendedSyncer fetches the extended forecast for the location and persists the
# weather points in the cache without storing it into the database.
#
# We could also store all these points in the database so we could build different
# kinds of extended forecasts (hourly, daily, etc), but this is not necessary in the
# current scope of the project.
#
module Locations
  class ExtendedSyncer
    include DataMapper

    def initialize(location)
      @location = location
      @forecaster = ForecastService.new(@location)
    end

    def sync
      Cache.write("extended_forecast", @location.id, build_points)
      @location.update(last_forecast_sync_at: Time.current)
    end

    private

    # Fetches the extended forecast data and convets it into individual WeatherPoint objects.
    # WeatherPoint holds the basic weather information.
    def build_points
      @forecaster.fetch_extended.map do |data|
        WeatherPoint.new(weather_point_attributes(data))
      end
    end
  end
end
