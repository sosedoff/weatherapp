require "rails_helper"

describe ScheduledSyncJob do
  include ActiveJob::TestHelper

  before(:each) do
    clear_enqueued_jobs
  end

  it "schedules forecast and extended forecast jobs for each stale location" do
    create_list(:location, 2, last_sync_at: 1.hour.ago)
    expect {
      ScheduledSyncJob.perform_now
    }.to change { enqueued_jobs.select { |j| j["job_class"] == "Locations::CurrentForecastJob" }.size }.by(2)
     .and change { enqueued_jobs.select { |j| j["job_class"] == "Locations::ExtendedForecastJob" }.size }.by(2)
  end

  it "does not schedule jobs for fresh locations" do
    create_list(:location, 2, last_sync_at: Time.current)
    expect {
      ScheduledSyncJob.perform_now
    }.not_to change { enqueued_jobs.size }
  end
end 
