# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.1'

gem 'actionpack', '>= 7.0.4.1'
gem 'actionview', '>= 7.0.4.1'
gem 'activerecord', '>= 7.0.4.1'
gem 'activesupport', '>= 7.0.4.1'
gem 'bootsnap', '>= 1.4.2'
gem 'chartkick', '>= 4.2.1'
gem 'devise'
gem 'devise-pwned_password'
gem 'faker'
gem 'groupdate'
gem 'hotwire-rails', '>= 0.1.3'
gem 'importmap-rails'
gem 'jbuilder', '>= 2.7'
gem 'money-rails', '~> 1.12'
gem 'nokogiri', '>= 1.13.10'
gem 'puma', '>= 5.6.4'
gem 'rails', '~> 7.2', '>= 7.2.2'
gem 'sprockets-rails'
gem 'sqlite3'
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
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webdrivers'
end
