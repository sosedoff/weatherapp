# ForecastService is responsible to interacting with Weather API client(s) and
# managing the data cache for subsequent calls, if they're necessary.
#
class ForecastService
  CACHE_PREFIX = "forecast"
  CACHE_TTL = 5.minutes.to_i

  def initialize(location)
    @client    = OpenWeather::Forecast::Client.new
    @coords    = location.latlon
    @cache_key = location.id
  end

  # Fetch current grabs the current weather data for a given coordinate from Weather API
  def fetch_current
    with_expiry("current") do
      @client.current(lat: @coords[0], lon: @coords[1])
    end
  end

  # Fetch current grabs the extended forecast for a given coordinate from Weather API
  def fetch_extended
    with_expiry("extended") do
      @client.daily5(lat: @coords[0], lon: @coords[1])
    end
  end

  private

  # Execute a block and store it into the cache with default expiration time.
  # We're treating all forecasting results with the same TTL.
  def with_expiry(kind)
    Cache.content_cache(CACHE_PREFIX, "#{@cache_key}_#{kind}", ttl: CACHE_TTL) do
      yield
    end
  end
end
