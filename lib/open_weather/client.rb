module OpenWeather
  class Client
    attr_reader :forecast, :geo

    def initialize(api_key: nil)
      @forecast = OpenWeather::Forecast::Client.new(api_key:)
      @geo      = OpenWeather::Geo::Client.new(api_key:)
    end
  end
end
