class LocationsController < ApplicationController
  before_action :require_search_query, only: [:search]

  # Display recently added locations
  # GET /
  # GET /locations
  def index
    @recent_locations = Location.recent.limit(10)
  end

  # Search locations by city, address or zipcode
  # POST /search
  def search
    # Fetch geolocation for the given address query.
    #
    # NOTE: we're always picking the first matched result here, so if geocoder is wrong we'll have to
    # supply a different query to be more precise.
    #
    geocode_entry = geocoder_service.geocode(@query)
    if !geocode_entry
      return redirect_to root_path, flash: { error: I18n.t("locations.not_found") }
    end

    # Manage location import and associated tasks (weather data sync, etc)
    location = LocationService.import(geocode_entry)
    unless location.persisted? && location.valid?
      return redirect_to root_path, flash: { error: I18n.t("locations.invalid") }
    end

    redirect_to current_weather_path(location)
  end

  private

  def search_params
    params.require(:search).permit(:address)
  end

  # Require the actual search query or redirect back home
  def require_search_query
    @query = search_params[:address]&.strip
    if @query.blank?
      redirect_to locations_path
    end
  end
end
