module OpenWeather
  class Config
    attr_accessor :api_key, :debug, :language, :units

    def initialize
      @api_key = ENV["OPENWEATHER_API_KEY"]
      @debug = false
      @language = "en"
      @units = "imperial"
    end
  end
end
