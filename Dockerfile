FROM ruby:3.2.8-slim

# Add source for nodejs packages
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -

RUN apt-get update -qq && \
    apt-get install -y build-essential git pkg-config libyaml-dev libpq-dev nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Add application user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

USER rails

# Configure home for the application
WORKDIR /home/rails/app

# Set production environment
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test"

# Install dependencies
ADD --chown=rails Gemfile Gemfile.lock .
RUN bundle install -j 4

# Add the rest of the codebase
ADD --chown=rails . .

# Precompile assets
RUN SECRET_KEY_BASE=test \
  bundle exec rails assets:precompile
