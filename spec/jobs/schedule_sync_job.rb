require "rails_helper"

describe ScheduledSyncJob do
  describe "#perform" do
    context "unsynced locations" do
      before do
        create :location, external_id: "a"
        create :location, external_id: "b"
        create :location, external_id: "c"
      end

      it "scheduled sync for all locations" do
        expect {
          described_class.new.perform
        }.to change { enqueued_jobs(Locations::CurrentForecastJob).size }.from(0).to(3)
      end
    end

    context "with stale locations" do
      before do
        create :location, external_id: "a", last_sync_at: Time.current
        create :location, external_id: "b", last_sync_at: Time.current
        create :location, external_id: "c", last_sync_at: Time.current - 45.minutes
      end

      it "scheduled sync for the stale locations" do
        expect {
          described_class.new.perform
        }.to change { enqueued_jobs(Locations::CurrentForecastJob).size }.from(0).to(1)
      end
    end
  end
end
