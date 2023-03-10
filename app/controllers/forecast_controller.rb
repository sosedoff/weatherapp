class ForecastController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_home
  before_action :require_location

  # Display current (and extended) weather at location
  # GET /weather/:id
  def current
    # All our current weather data is cached BY DEFAULT, ie when we sync with the
    # weather service, we cache the raw data first (so it could be queried/retried),
    #
    # then save the record holding the current data.
    # These weather points get updated automatically in the background.
    #
    @point, @cached = Cache.wrap("current", @location.id, ttl: 30.minutes) do
      @location.weather_point
    end

    # We do not fetch the extended forecast data by default. When location needs to
    # be refreshed, we grab the extended forecast and cache it for 24 hours or
    # until the next location refresh.
    @extended = load_extended_forecast
  end

  # Display extended weather forecast (5day/3h)
  # GET /weather/:id/extended
  def extended
    @extended = load_extended_forecast
  end

  private

  def require_location
    @location = Location.includes(:weather_point).find(params[:id])
  end

  def redirect_to_home
    redirect_to root_path, flash: { error: I18n.t("locations.not_found") }
  end

  def load_extended_forecast
    Cache.read("extended_forecast", @location.id)
  end
end
