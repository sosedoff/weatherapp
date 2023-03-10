# Weather point contains the basic weather data for the current and extended forecasts:
#
# - external_id - reference for the resource in the external service
# - lat,log - coordinates of the location
# - temp (current, min, max)
# - pressure
# - humidity
#
class WeatherPoint < ApplicationRecord
  belongs_to :location

  validates :external_id, presence: true
  validates :temp, :pressure, :visibility, :wind_speed, :ts, presence: true

  def timestamp
    @timestamp ||= Time.at(ts, in: utc_offset)
  end

  def sunrise_timestamp
    @sunrise_timestamp ||= Time.at(sunrise_ts, in: utc_offset)
  end

  def sunset_timestamp
    @sunset_timestamp ||= Time.at(sunset_ts, in: utc_offset)
  end
end
