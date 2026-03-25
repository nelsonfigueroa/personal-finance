# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.7'

gem 'bootsnap', '>= 1.4.2'
gem 'chartkick', '>= 4.2.1'
gem 'devise'
gem 'devise-pwned_password'
gem 'faker'
gem 'groupdate'
gem 'importmap-rails'
gem 'jbuilder', '>= 2.7'
gem 'money-rails', '~> 3.0'
gem 'nokogiri', '>= 1.13.10'
gem 'puma', '>= 5.6.4'
gem 'rails', '~> 8.1'
gem 'sprockets-rails'
gem 'sqlite3'
gem 'stimulus-rails'
gem 'turbo-rails', '>= 2.0.5'
gem 'tzinfo-data'

group :development, :test do
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'pry', '>= 0.12.2'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '>= 6.1'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'brakeman'
  gem 'bullet'
  gem 'debugbar'
  gem 'listen'
  gem 'rails_live_reload'
  gem 'seed_dump'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
