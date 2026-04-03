# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.4'

gem 'bootsnap', '>= 1.16.0', require: false
gem 'devise', '~> 4.9'
gem 'jbuilder', '~> 2.11'
gem 'jwt', '>= 2.8.0'
gem 'pagy', '~> 9.0'
gem 'pg', '~> 1.4', '>= 1.4.0'
gem 'puma', '~> 6.4'
gem 'rails', '~> 8.0'
gem 'solid_queue'

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.0'
  gem 'rspec-rails', '~> 7.0'
end

group :development do
  gem 'letter_opener', '~> 1.10'
  gem 'rack-mini-profiler', '~> 2.3'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov_json_formatter', '~> 0.1.4', require: false
end

gem 'kamal', require: false
gem 'thruster', require: false

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
