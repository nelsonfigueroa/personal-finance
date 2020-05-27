# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'actionpack', '>= 6.0.3.1'
gem 'activestorage', '>= 6.0.3.1'
gem 'actionview', '>= 6.0.2.2'
gem 'activesupport', '>= 6.0.3.1'
gem 'bulma-rails', '~> 0.8.0'
gem 'chartkick'
gem 'devise'
gem 'groupdate'
gem 'inline_svg'
gem 'pg', '~> 0.18.4'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'pry', '~> 0.12.2'
  # for rails 6 compatability
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.0.beta2'

  gem 'rubocop-rails', require: false
end

group :development do
  gem 'bullet'
  gem 'seed_dump'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

gem 'tzinfo-data'
