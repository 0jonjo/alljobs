# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.6'

gem 'bootsnap', '>= 1.16.0', require: false
gem 'devise', '~> 4.9'
gem 'jbuilder', '~> 2.11'
gem 'jwt', '>= 2.8.0'
gem 'pg', '~> 1.4', '>= 1.4.0'
gem 'puma', '~> 6.4'
gem 'rails', '~> 7.1'
gem 'sass-rails', '>= 6'
gem 'solid_queue'


group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.0'
  gem 'rspec-rails', '~> 6.1'
  gem 'rubycritic', require: false
end

group :development do
  gem 'listen', '~> 3.7'
  gem 'rack-mini-profiler', '~> 2.3'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'web-console', '>= 4.2.0'
end

group :test do
  gem 'selenium-webdriver', '~> 4.1'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov_json_formatter', '~> 0.1.4', require: false
  gem 'webdrivers', '~> 5.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
