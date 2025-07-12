# Geocoder service is responsible for fetching geographic location for a given address/zipcode.
#
# Location data comes from an external API and then stored in cache (could be stored for a long time).
# Data source could be swapped out by setting a new provider class in the initializer.
#
class GeocoderService
  CACHE_PREFIX = "geocoder"

  def geocode(input)
    #Cache.query_cache(CACHE_PREFIX, input) do
    #fail "IM SEARCHING FOR #{input},. provider: #{Geocoding.provider.inspect}"
    Geocoding.provider.lookup(input)
    #end
  end
end
