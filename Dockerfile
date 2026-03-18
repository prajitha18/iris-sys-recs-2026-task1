# Use the official Ruby image
FROM ruby:3.4.1

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    default-mysql-client \
    yarn


# Set working directory
WORKDIR /app

# Copy Gemfiles first
COPY Gemfile* ./

# Install gems
RUN bundle install

# Copy the rest of the app
COPY . .

# Precompile assets (optional for production)
RUN bundle exec rails assets:precompile

# Expose Rails port
EXPOSE 3000

CMD ["sh", "-c", "sleep 10 && bundle exec rails db:prepare && rails server -b 0.0.0.0"]
