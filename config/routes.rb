require "sidekiq/web"

Rails.application.routes.draw do
  root "locations#index"

  # Locations management
  get "locations", to: "locations#index"
  post "search", to: "locations#search"

  # Current weather and forecasting pages
  get "weather/:id", to: "forecast#current", as: "current_weather"
  get "weather/:id/extended", to: "forecast#extended", as: "extended_weather"

  # Sidekiq UI for inspecting jobs
  if Rails.env.development? || ENV["SIDEKIQ_WEB_ENABLED"] == "true"
    mount Sidekiq::Web => "/_sidekiq"
  end
end
