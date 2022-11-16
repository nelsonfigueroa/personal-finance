# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'actionpack', '>= 7.0.4'
gem 'actionview', '>= 7.0.4'
gem 'activerecord', '>= 7.0.4'
gem 'activesupport', '>= 7.0.4'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'chartkick', '~> 4.2.1'
gem 'devise'
gem 'devise-pwned_password'
gem 'groupdate'
gem 'hotwire-rails', '~> 0.1.3'
gem 'importmap-rails'
gem 'inline_svg'
gem 'jbuilder', '~> 2.7'
gem 'money-rails', '~>1.12'
gem 'nokogiri', '>= 1.13.9'
gem 'pg', '~> 1.2.3'
gem 'psych', '< 4' # fixes Psych::BadAlias errors
gem 'puma', '>= 5.6.4'
gem 'rails', '~> 7.0.4'
gem 'sassc-rails'
gem 'sqlite3'
gem 'turbolinks', '~> 5.2.1'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

group :development, :test do
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'pry', '~> 0.12.2'
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
