require "rails_helper"

describe Locations::Importer do
  let(:entry)   { Geocoding::Entry.new }
  let(:service) { described_class.new(entry) }

  before do
    allow(Locations::CurrentForecastJob).to receive(:perform_later)
    allow(Locations::ExtendedForecastJob).to receive(:perform_later)
  end

  describe "#initialize" do
    it "requires entry id" do
      entry = Geocoding::Entry.new
      expect { described_class.new(entry) }.to raise_error ArgumentError, "entry.id value is required"
    end
  end

  describe "#import" do
    let(:entry) do
      Geocoding::Entry.new(
        id: "external_id",
        city: "Chicago",
        state: "Illinois",
        country: "United States",
        lat: 1.0,
        lon: 1.0
      )
    end

    context "new location" do
      it "returns a new record" do
        result = service.import

        expect(result).to be_a Location
        expect(result).to be_valid
        expect(result.external_id).to eq entry.id
        expect(result.city).to eq entry.city
        expect(result.state).to eq entry.state
        expect(result.country).to eq entry.country
        expect(result.lat).to eq entry.lat
        expect(result.lon).to eq entry.lon
      end

      it "creates a new location record" do
        expect { service.import }.to change { Location.count }.from(0).to(1)
      end

      it "schedules background jobs" do
        result = service.import

        expect(Locations::CurrentForecastJob).to have_received(:perform_later).with(result.id)
        expect(Locations::ExtendedForecastJob).to have_received(:perform_later).with(result.id)
      end
    end

    context "existing location" do
      let!(:location) { create(:location) }

      before do
        entry.id = location.external_id
      end

      it "returns already existing location" do
        expect(Locations::CurrentForecastJob).to_not receive(:perform_later)
        expect(Locations::ExtendedForecastJob).to_not receive(:perform_later)

        result = service.import
        expect(result).to be_a ::Location
        expect(result.id).to eq location.id
        expect(result.external_id).to eq location.external_id
      end
    end
  end
end
