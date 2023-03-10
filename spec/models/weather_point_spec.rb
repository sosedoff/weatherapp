require "rails_helper"

describe WeatherPoint do
  describe "validations" do
    let(:point) { described_class.new }

    it "requires attributes" do
      expect(point).to_not be_valid
      expect(point.errors[:external_id]).to include "can't be blank"
      expect(point.errors[:temp]).to include "can't be blank"
      expect(point.errors[:pressure]).to include "can't be blank"
      expect(point.errors[:visibility]).to include "can't be blank"
      expect(point.errors[:wind_speed]).to include "can't be blank"
      expect(point.errors[:ts]).to include "can't be blank"
    end
  end

  describe "timestamps" do
    let(:point) { create(:weather_point) }

    it "returns timestamp" do
      expect(point.timestamp).to be_a Time
    end

    it "returns sunrise timestamp" do
      expect(point.sunrise_timestamp).to be_a Time
    end

    it "returns sunset timestamp" do
      expect(point.sunset_timestamp).to be_a Time
    end
  end
end
