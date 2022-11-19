# Personal Finance

Personal Finance is a Ruby on Rails application that keeps track of finances over time. I built it for myself because other apps are either too bloated for my taste, or privacy-invasive (i.e. Mint).

It is currently barebones as I'm reworking the entire thing.

Long-term goals:
- [x] Net worth tracking over time
- [x] Expense tracking
- [ ] Income vs expenses per month
- [ ] Stock dividend tracking
- [ ] Liability tracking

## Notable Gems and Libraries used:

- [Water.css](https://watercss.kognise.dev/) - Drop-in CSS styles.
- [RSpec](https://github.com/rspec/rspec-rails) - For writing tests.
- [simplecov](https://github.com/colszowka/simplecov) - Provides test coverage analysis.
- [Rubocop](https://github.com/rubocop-hq/rubocop-rails) - Linting for Ruby code. 
- [erb-lint](https://github.com/Shopify/erb-lint) - Linting for `.erb` files.
- [Chartkick](https://chartkick.com/) - Generates JavaScript graphs and charts.
- [devise-pwned_password](https://github.com/michaelbanfield/devise-pwned_password) - Gem that checks if Devise Models are using passwords that have shown up in data breaches. Powered by the [pwned](https://github.com/philnash/pwned) gem.
- Docker - A Dockerfile and docker-compose file are included for local development and previewing purposes. 
- PostgreSQL - As the database
- [Bullet](https://github.com/flyerhzm/bullet) - To ensure database queries are efficient
- [brakeman](https://github.com/presidentbeef/brakeman) - To check for security vulnerabiliies

## Running Locally

You can run this application locally using Docker.

Build the app and set up the database container:

```
docker-compose run web rake db:create db:setup
```

Start up the Rails server and database:

```
docker-compose up
```

Then browse to `http://localhost:3000/`.

You can use the demo user credentials to try out the app:
- Email: `demo@demo`
- Password: `demouser123!`

Or you can create a new account.

## Cleaning Up

To take down the application run:

```
docker-compose down
```

If you don't plan on using Docker for other purposes, you can clean up the Docker images that were downloaded as well:

```
docker system prune -a --volumes
```
