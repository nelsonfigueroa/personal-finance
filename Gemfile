# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'actionpack', '~> 6.1.4.1'
gem 'actionview', '~> 6.1.3'
gem 'activerecord', '~> 6.1.3'
gem 'activesupport', '~> 6.1.3'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'chartkick', '~> 3.4.2'
gem 'devise'
gem 'devise-pwned_password'
gem 'groupdate'
gem 'inline_svg'
gem 'jbuilder', '~> 2.7'
gem 'money-rails', '~>1.12'
gem 'nokogiri', '>= 1.12.5'
gem 'pg', '~> 1.2.3'
gem 'puma', '>= 4.3.9'
gem 'rails', '~> 6.1.4.1'
gem "sassc-rails"
gem 'turbolinks', '~> 5.2.1'
gem 'webpacker', '~> 5.2.1'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

group :development, :test do
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'pry', '~> 0.12.2'
  # for rails 6 compatability
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 5.0.1'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'brakeman'
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'seed_dump'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'sqlite3'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'faker'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

gem 'tzinfo-data'
