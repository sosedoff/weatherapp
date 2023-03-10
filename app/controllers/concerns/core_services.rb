module CoreServices
  extend ActiveSupport::Concern

  def geocoder_service
    @_geocoder_service ||= GeocoderService.new
  end

  def forecasting_service
    @_forecasting_service ||= ForecastService.new(@location)
  end
end
