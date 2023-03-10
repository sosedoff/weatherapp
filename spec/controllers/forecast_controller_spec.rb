require "rails_helper"

describe ForecastController do
  let(:location) { create :location }

  describe "#current" do
    it "loads the page" do
      get :current, params: { id: location.id }
      expect(response.status).to eq 200
    end

    context "invalid location" do
      it "redirects back home" do
        get :current, params: { id: "foo" }

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq "We could not find the requested location"
      end
    end
  end

  describe "#extended" do
    it "loads the page" do
      get :extended, params: { id: location.id }
      expect(response.status).to eq 200
    end

    context "invalid location" do
      it "redirects back home" do
        get :extended, params: { id: "foo" }

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq "We could not find the requested location"
      end
    end
  end
end
