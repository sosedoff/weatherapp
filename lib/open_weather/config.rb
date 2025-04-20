module OpenWeather
  class Config
    attr_accessor :api_key, :debug, :language, :units

    def initialize
      @api_key  = ENV["OPENWEATHER_API_KEY"]
      @units    = ENV.fetch("OPENWEATHER_UNITS", "imperial")
      @debug    = false
      @language = "en"
    end
  end
end
