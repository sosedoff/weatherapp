require "rails_helper"

describe LocationsController, type: :controller do
  let(:geocoder) { instance_double(GeocoderService) }

  before do
    allow(GeocoderService).to receive(:new) { geocoder }
  end

  describe "#index" do
    it "renders home page" do
      get :index
      expect(response.status).to eq 200
    end
  end

  describe "#search" do
    context "invalid geocoder reply" do
      before do
        allow(geocoder).to receive(:geocode).with("city") { nil }
      end

      it "redirects to home page" do
        post :search, params: { search: { address: "city" } }

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq "We could not find the requested location"
      end
    end

    context "invalid geocoder data" do
      before do
        allow(geocoder).to receive(:geocode).with("city") do
          Geocoding::Entry.new(id: "a", city: "City")
        end
      end

      it "redirects to home page" do
        post :search, params: { search: { address: "city" } }

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq "The requested location is not valid"
      end
    end

    context "valid geocoder data" do
      before do
        allow(geocoder).to receive(:geocode).with("city") do
          Geocoding::Entry.new(
            id: "id",
            city: "Chicago",
            state: "Illinois",
            country: "United States",
            zipcode: "60622",
            lat: 100,
            lon: 100
          )
        end
      end

      it "imports the location and redirec to details page" do
        expect { post :search, params: { search: { address: "city" } } }.
          to change { Location.count }.from(0).to(1)

        location = Location.first
        expect(response).to redirect_to(current_weather_path(location))
      end
    end

    context "existing location" do
      let!(:location) { create :location }

      before do
        allow(geocoder).to receive(:geocode).with("city") do
          Geocoding::Entry.new(
            id: location.external_id,
            city: "Chicago",
            state: "Illinois",
            country: "United States",
            zipcode: "60622",
            lat: 100,
            lon: 100
          )
        end
      end

      it "imports the location and redirec to details page" do
        expect { post :search, params: { search: { address: "city" } } }.
          to_not change { Location.count }

        expect(response).to redirect_to(current_weather_path(location))
      end
    end
  end
end
