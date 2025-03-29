source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.8"

gem "dotenv-rails"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "foreman"
gem "faraday", "~> 2.0"
gem "lograge", "~> 0.12.0"
gem "geocoder", "~> 1.8"
gem "bootstrap", "~> 5.2"
gem "redis"
gem "sidekiq", "~> 6.0"
gem "sidekiq-cron"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "nio4r", "~> 2.7.4", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rspec-core"
  gem "rspec-rails"
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "database_cleaner"
end


