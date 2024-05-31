# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.5"

gem "active_model_serializers", "~> 0.10.14"
gem "bootsnap", ">= 1.4.4", require: false
gem "devise"
gem "jbuilder", "~> 2.7"
gem "jwt", ">= 2.8.0"
gem "kaminari", "~> 1.2", ">= 1.2.1"
gem "pg", "~> 1.2", ">= 1.2.3"
gem "puma", "~> 6.4"
gem "rails", "~> 7.1"
gem "sass-rails", ">= 6"
gem "sidekiq"
gem "turbolinks", "~> 5"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails", "~> 6.2"
  gem "faker"
  gem "rspec-rails", "~> 6.1"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.0"
  gem "simplecov", "~> 0.22.0", require: false
  gem "simplecov_json_formatter", "~> 0.1.4", require: false
  gem "webdrivers"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
