require "rails_helper"

describe ForecastService do
  let(:location) { create :location }
  let(:service)  { described_class.new(location) }
  let(:client)   { instance_double(OpenWeather::Forecast::Client) }

  before do
    allow(OpenWeather::Forecast::Client).to receive(:new) { client }

    allow(client).to receive(:current).with(lat: location.lat, lon: location.lon) do
      { "cod" => 200, "data" => {} }
    end

    allow(client).to receive(:daily5).with(lat: location.lat, lon: location.lon) do
      { "cod" => 200, "data2" => {} }
    end

    allow(Cache).to receive(:content_cache).and_call_original
  end

  describe "#fetch_current" do
    it "returns the current weather" do
      result = service.fetch_current

      expect(result).to be_a Hash
      expect(result["cod"]).to eq 200
      expect(result["data"]).to be_a Hash

      expect(Cache).to have_received(:content_cache).with(
        "forecast", "#{location.id}_current", ttl: 300
      )
    end
  end

  describe "#fetch_extended" do
    it "returns the extended forecast" do
      result = service.fetch_extended

      expect(result).to be_a Hash
      expect(result["cod"]).to eq 200
      expect(result["data2"]).to be_a Hash

      expect(Cache).to have_received(:content_cache).with(
        "forecast", "#{location.id}_extended", ttl: 300
      )
    end
  end
end
