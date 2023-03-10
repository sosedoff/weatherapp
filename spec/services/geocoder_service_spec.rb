require "rails_helper"

describe GeocoderService do
  let(:service) { described_class.new }

  before do
    allow(Geocoding.provider).to receive(:lookup).with("valid") { "exists" }
    allow(Geocoding.provider).to receive(:lookup).with("invalid") { nil }
    allow(Cache).to receive(:query_cache).and_call_original
  end

  describe "#geocode" do
    it "returns the geocoding result" do
      # Calls hit the geocoding provider
      expect(service.geocode("valid")).to eq "exists"
      expect(service.geocode("invalid")).to eq nil

      # Calls hit the caching module
      expect(Cache).to have_received(:query_cache).with("geocoder", "valid")
      expect(Cache).to have_received(:query_cache).with("geocoder", "invalid")
    end
  end
end
