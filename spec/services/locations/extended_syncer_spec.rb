require "rails_helper"

describe Locations::ExtendedSyncer do
  let(:location) { create :location }
  let(:service)  { described_class.new(location) }
  let(:forecaster) { instance_double(ForecastService) }

  before do
    allow(ForecastService).to receive(:new) { forecaster }
    allow(forecaster).to receive(:fetch_extended) do
      read_json_fixture("open_weather/forecast.json")
    end
  end

  describe "#sync" do
    it "saves the forecast data" do
      points = []
      allow(Cache).to receive(:write) { |prefix, key, data| points = data }

      expect(service.sync).to eq true
      expect(points.size).to eq 40
      expect(points.first).to be_a WeatherPoint
      expect(Cache).to have_received(:write).with("extended_forecast", location.id, Array)
    end

    it "updates sync status" do
      expect { service.sync }.
        to change { location.last_forecast_sync_at }.from(nil).to(Time)
    end
  end
end
