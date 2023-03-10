class BaseSyncJob < ApplicationJob
  sidekiq_options retry: 3
end
