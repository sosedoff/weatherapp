FactoryBot.define do
  factory :weather_point do
    location { create :location }
    external_id { "ext_id" }
    utc_offset { -21600 }
    temp { 30 }
    temp_min { 28 }
    temp_max { 35 }
    temp_feels_like { 31 }
    pressure { 1000 }
    visibility { 1200 }
    wind_speed { 8 }
    condition { "Windy" }
    ts { Time.current.to_i }
    sunrise_ts { Time.current.to_i }
    sunset_ts { Time.current.to_i }
  end
end
