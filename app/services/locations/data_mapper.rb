# DataMapper translates raw data from the Weather client into "our" own format,
# ie. compatible with WeatherPoint model.
#
# This mapping functionality ideally should be moved into the API client itself,
# but we're leaving it here for demo purposes only.
#
module Locations
  module DataMapper
    def weather_point_attributes(data)
      {
        external_id:     data["id"].to_s,
        utc_offset:      data["timezone"],
        lat:             data.dig("coord", "lat"),
        lon:             data.dig("coord", "lon"),
        condition:       data["weather"][0]["main"],
        condition_code:  data["weather"][0]["icon"],
        temp:            data["main"]["temp"].to_i,
        temp_max:        data["main"]["temp_max"].to_i,
        temp_min:        data["main"]["temp_min"].to_i,
        temp_feels_like: data["main"]["feels_like"].to_i,
        humidity:        data["main"]["humidity"],
        pressure:        data["main"]["pressure"],
        visibility:      data["visibility"],
        wind_speed:      data["wind"]["speed"],
        sunrise_ts:      data["sys"]["sunrise"],
        sunset_ts:       data["sys"]["sunset"],
        ts:              data["dt"]
      }
    end
    module_function :weather_point_attributes
  end
end
