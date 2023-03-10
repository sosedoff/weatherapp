require "rails_helper"

describe Location do
  let(:location) { create(:location) }

  describe "defaults" do
    it "has a stale threshold" do
      expect(described_class::STALE_THRESHOLD).to eq 5.minutes
    end
  end

  describe "validations" do
    let(:location) { Location.new }

    it "requires attributes" do
      expect(location).to_not be_valid
      expect(location.errors[:external_id]).to include "can't be blank"
      expect(location.errors[:city]).to include "can't be blank"
      expect(location.errors[:state]).to include "can't be blank"
      expect(location.errors[:country]).to include "can't be blank"
      expect(location.errors[:lat]).to include "can't be blank"
      expect(location.errors[:lon]).to include "can't be blank"
    end
  end

  describe "#display_name" do
    it "returns the city and state" do
      expect(location.display_name).to eq "Chicago, Illinois"
    end
  end

  describe "#latlon" do
    it "returns the geo coordinate" do
      expect(location.latlon).to eq [location.lat, location.lon]
    end
  end

  describe ".stale" do
    before do
      create :location, external_id: "a"
      create :location, external_id: "b", last_sync_at: Time.current
      create :location, external_id: "c", last_sync_at: Time.current - 45.minutes
    end

    it "returns locations with stale weather data" do
      locations = Location.stale

      expect(locations.size).to eq 2
      expect(locations.map(&:external_id).sort).to eq ["a", "c"]
    end
  end

  describe "#should_sinc?" do
    it "returns true if location data is stale" do
      loc = Location.new
      expect(loc.should_sync?).to eq true

      loc.last_sync_at = Time.current - 3.minutes
      expect(loc.should_sync?).to eq false

      loc.last_sync_at = Time.current - 60.minutes
      expect(loc.should_sync?).to eq true
    end
  end

  describe "#schedule_sync" do
    let(:adapter) { Locations::CurrentForecastJob.queue_adapter }

    it "schedules background jobs" do
      expect { location.schedule_sync }.
        to change { adapter.enqueued_jobs.size }.by(2)
    end
  end
end
