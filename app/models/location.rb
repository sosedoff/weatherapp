# Location contains the geocoded data for an address or a city:
#
# - external_id - reference to the resource in the external service / api
# - city, state, country, zipcode - basic location info
# - utc_offset - to display the time at the location
# - lat, lon - coordinates for the forecasting
#
class Location < ApplicationRecord
  STALE_THRESHOLD = 5.minutes.to_i

  has_one :weather_point, dependent: :delete

  validates :external_id, presence: true, uniqueness: { case_sensitive: false }
  validates :city, :state, :country, :lat, :lon, presence: true

  scope :recent, -> { includes(:weather_point).order(last_sync_at: :desc) }
  scope :stale, -> { where(last_sync_at: nil).or(where("last_sync_at < ?", Time.current - STALE_THRESHOLD)) }

  # Display name does not care about country for simplicity
  def display_name
    "#{city}, #{state}"
  end

  # Return latitude,longitude point
  def latlon
    [lat, lon]
  end

  # Determines if location weather data should be updated
  def should_sync?
    last_sync_at.nil? || Time.current - last_sync_at > STALE_THRESHOLD
  end

  # Trigger resync of weather data
  def schedule_sync
    Locations::CurrentForecastJob.perform_later(self.id)
    Locations::ExtendedForecastJob.perform_later(self.id)
  end
end
