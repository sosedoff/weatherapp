require "rails_helper"

describe Locations::ExtendedForecastJob do
  let(:location) { create :location }

  describe "#perform" do
    it "runs the weather sync" do
      expect(LocationService).to receive(:sync_extended).with(location)
      described_class.new.perform(location.id)
    end
  end
end
