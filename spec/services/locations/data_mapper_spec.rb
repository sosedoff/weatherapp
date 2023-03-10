require "rails_helper"

describe Locations::DataMapper do
  describe "#weather_point_attributes" do
    let(:data) do
      read_json_fixture("open_weather/current.json")
    end

    it "returns attribute for WeatherPoint record" do
      expect(described_class.weather_point_attributes(data)).to eq Hash(
        :external_id => "4891431",
        :utc_offset => -21600,
        :lat => 41.764,
        :lon => -87.6554,
        :condition => "Mist",
        :condition_code => "50d",
        :temp => 35,
        :temp_max => 37,
        :temp_min => 34,
        :temp_feels_like => 27,
        :humidity => 89,
        :pressure => 1017,
        :visibility => 9656,
        :wind_speed => 11.5,
        :sunrise_ts => 1678450282,
        :sunset_ts => 1678492245,
        :ts => 1678473046
      )
    end
  end
end
