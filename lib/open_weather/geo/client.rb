module OpenWeather
  module Geo
    class Client < OpenWeather::Base
      API_URL = OpenWeather::Endpoints::GEO
      LIMIT = 10

      # Geocodes based on the given location string (City, State)
      #
      # query - address or location
      # params - additional
      #
      def address(query, params = {})
        get("/direct", { q: query, limit: LIMIT }.merge(params))
      end

      # Geocodes by a given ZIP code (ex: 60622)
      #
      # zip - six digit zip code
      #
      def zipcode(zip)
        get("/zip", zip:)
      end
    end
  end
end
