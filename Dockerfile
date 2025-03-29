FROM ruby:3.2.8-slim

RUN apt-get update -y && \
    apt-get install -y build-essential git pkg-config libyaml-dev libpq-dev nodejs

WORKDIR /app

# Install dependencies
ADD Gemfile Gemfile.lock .
RUN bundle install -j 4

# Add the rest of the codebase
ADD . .

# Precompile assets
RUN bundle exec rails assets:precompile
