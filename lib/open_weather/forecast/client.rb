require "open_weather/forecast/types"

module OpenWeather
  module Forecast
    class Client < Base
      API_URL = OpenWeather::Endpoints::DATA

      # Returns the current weather for the given geo coordinates
      def current(lat:, lon:)
        get("/weather", default_params.merge(lat:, lon:))
      end

      # Returns a 5 day forecast data with 3-hour step
      def daily5(lat:, lon:)
        get("/forecast", default_params.merge(lat:, lon:))["list"]
      end
    end
  end
end
