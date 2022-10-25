# Personal Finance

![Ruby](https://img.shields.io/badge/Ruby-3.0.0-RED?logo=ruby) ![Rails](https://img.shields.io/badge/Rails-6.1.4-RED?logo=rails)

## What is it?

Personal Finance is a Ruby on Rails application that keeps track of finances over time. I built it for myself because other apps are either too bloated for my taste, or privacy-invasive (i.e. Mint).

It is currently barebones as I'm reworking the entire thing.

Long-term goals:
- Net worth tracking over time
- Expense tracking
- Income vs expenses per month
- Stock dividend tracking
- Liability tracking

## Notable Gems and Libraries used:

- [Water.css](https://watercss.kognise.dev/) - Drop-in CSS styles.
- [RSpec](https://github.com/rspec/rspec-rails) - For writing tests.
- [simplecov](https://github.com/colszowka/simplecov) - Provides test coverage analysis.
- [Rubocop](https://github.com/rubocop-hq/rubocop-rails) - To keep my Ruby code clean. 
- [erb-lint](https://github.com/Shopify/erb-lint) - To keep code in `.erb` files clean.
- [Chartkick](https://chartkick.com/) - Generates JavaScript graphs and charts.
- [devise-pwned_password](https://github.com/michaelbanfield/devise-pwned_password) - Gem that checks if Devise Models are using passwords that have shown up in data breaches. Powered by the [pwned](https://github.com/philnash/pwned) gem.
- Docker - A Dockerfile and docker-compose file are included for local development and previewing purposes. 
- PostgreSQL - As the database
- [Bullet](https://github.com/flyerhzm/bullet) - To ensure database queries are efficient
- [brakeman](https://github.com/presidentbeef/brakeman) - To check for security vulnerabiliies

## Running Locally

You can run this application locally using `docker-compose`.

Build the app and set up the database container:

```
docker-compose run web rake db:create db:setup
```

Start up the Rails server and database:

```
docker-compose up
```

Then browse to `http://localhost:3000/`.

To take down the application:

```
docker-compose down
```
