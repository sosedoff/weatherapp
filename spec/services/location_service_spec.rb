require "rails_helper"

describe LocationService do
  let(:location) { create(:location) }
  let(:geocode_entry) { instance_double("Geocoding::Entry", lat: 40.7128, lon: -74.0060, display_name: "New York") }

  describe ".sync_current" do
    let(:syncer) { instance_double(Locations::Syncer) }

    subject { described_class.sync_current(location) }

    before do
      allow(Locations::Syncer).to receive(:new).with(location) { syncer }
      allow(syncer).to receive(:sync)
    end

    it "delegates to Locations::Syncer" do
      subject
      expect(Locations::Syncer).to have_received(:new).with(location)
      expect(syncer).to have_received(:sync)
    end

    it "returns the result from the syncer" do
      allow(syncer).to receive(:sync).and_return(:success)
      expect(subject).to eq(:success)
    end
  end

  describe ".sync_extended" do
    let(:extended_syncer) { instance_double(Locations::ExtendedSyncer) }

    subject { described_class.sync_extended(location) }

    before do
      allow(Locations::ExtendedSyncer).to receive(:new).with(location) { extended_syncer }
      allow(extended_syncer).to receive(:sync)
    end

    it "delegates to Locations::ExtendedSyncer" do
      subject
      expect(Locations::ExtendedSyncer).to have_received(:new).with(location)
      expect(extended_syncer).to have_received(:sync)
    end

    it "returns the result from the extended syncer" do
      allow(extended_syncer).to receive(:sync).and_return(:success)
      expect(subject).to eq(:success)
    end
  end

  describe ".import" do
    let(:importer) { instance_double(Locations::Importer) }

    subject { described_class.import(geocode_entry) }

    before do
      allow(Locations::Importer).to receive(:new).with(geocode_entry) { importer }
      allow(importer).to receive(:import)
    end

    it "delegates to Locations::Importer" do
      subject
      expect(Locations::Importer).to have_received(:new).with(geocode_entry)
      expect(importer).to have_received(:import)
    end

    it "returns the result from the importer" do
      allow(importer).to receive(:import).and_return(location)
      expect(subject).to eq(location)
    end
  end
end 
