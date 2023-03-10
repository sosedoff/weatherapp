require "rails_helper"

describe Locations::Syncer do
  let(:location)   { create(:location) }
  let(:service)    { described_class.new(location) }
  let(:forecaster) { instance_double(ForecastService) }

  before do
    allow(ForecastService).to receive(:new).with(location) { forecaster }

    allow(forecaster).to receive(:fetch_current) do
      read_json_fixture("open_weather/current.json")
    end
  end

  describe "#sync" do
    context "no weather point" do
      it "creates a new weather point" do
        expect(location.weather_point).to eq nil
        expect { service.sync }.to change { WeatherPoint.count }.from(0).to(1)
        expect(location.reload.weather_point).to be_a WeatherPoint
      end

      it "updates the sync status" do
        expect { service.sync }.
          to change { location.last_sync_at }.from(nil).to(Time)
      end
    end

    context "with existing weather point" do
      let!(:point) { create :weather_point, temp: 100, location_id: location.id }

      it "updates the data" do
        service.sync
        point.reload

        expect(point.ts).to eq 1678473046
        expect(point.temp).to eq 35
      end

      it "updates the sync status" do
        expect { service.sync }.to change { location.last_sync_at }.from(nil).to(Time)
      end
    end

    context "with same data" do
      let!(:point) { create :weather_point, ts: 1678473046, location_id: location.id }

      it "skips data updates" do
        expect { service.sync }.to_not change { point.reload.ts }
      end

      it "updates the sync status" do
        expect { service.sync }.to change { location.last_sync_at }.from(nil).to(Time)
      end
    end
  end
end
