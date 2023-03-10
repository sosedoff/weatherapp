module OpenWeather
  class Base
    BadRequest = Class.new(StandardError)

    attr_reader :connection

    # Initialize a base OpenWeather client class
    #
    # api_key - (optional) service API key, or use global OpenWeather.api_key
    # base_url - (optional) base service API URL; auto-detected in service clients
    #
    def initialize(api_key: nil, base_url: nil)
      @api_key    = api_key
      @base_url   = base_url || default_api_url

      if !@base_url
        raise ArgumentError, "base url is not set"
      end

      @connection = build_connection
    end

    # Perform a GET request for a given path
    #
    # path - request path
    # params - request query parameters
    # headers - custom headers set
    #
    def get(path, params = {}, headers = {})
      resp = connection.get("#{@base_url}#{path}", params, headers) do |req|
        req.params[:appid] = @api_key || OpenWeather.api_key
      end

      unless resp.success?
        raise BadRequest, resp.body["message"]
      end

      resp.body
    end

    private

    def default_params
      {
        units: OpenWeather.units,
        language: OpenWeather.language,
        mode: "json"
      }
    end

    # Determine the base API url from specific client classes
    def default_api_url
      if self.class.const_defined?(:API_URL)
        self.class.const_get(:API_URL)
      end
    end

    # Configure the basic service connection
    #
    def build_connection
      Faraday.new(url: @base_url) do |conn|
        conn.request :json
        conn.response :json

        # Enable debug logging of API response.
        # We also filter out API key.
        if OpenWeather.debug
          conn.response :logger do |logger|
            logger.filter(/(appid=)([^&]+)/, '\1[REMOVED]')
          end
        end
      end
    end
  end
end
