# Personal Finance

Personal Finance is a Ruby on Rails application to keep track of finances in USD.

## Motivation

I built this for myself because other apps are either too complex for my needs ([Firefly III](https://www.firefly-iii.org/)), privacy-invasive ([Mint](https://mint.intuit.com/)), or have a subscription-based business model ([Copilot Money](https://copilot.money/)). I also don't like connecting my financial accounts to third party sites for security reasons, so this is a manual approach to tracking money. Since I built this for myself, it's a highly opinionated way of tracking finances.

## Running Locally

You can run this application locally using Docker.

Build the app and set up the database container:

```shell
docker-compose run web rake db:create db:setup
```

Start up the Rails server and database:

```shell
docker-compose up
```

Then browse to `http://localhost:3000/`.

You can use the demo user credentials to try out the app:
- Email: `demo@demo`
- Password: `demouser123!`

Or you can create a new account.

## Cleaning Up

To take down the application run:

```shell
docker-compose down
```

If you don't plan on using Docker for other purposes, you can clean up the Docker images that were downloaded as well:

```shell
docker system prune -a --volumes
```

## Notable Gems and Libraries used:

- [RSpec](https://github.com/rspec/rspec-rails) - For writing tests.
- [simplecov](https://github.com/colszowka/simplecov) - Provides test coverage analysis.
- [Rubocop](https://github.com/rubocop-hq/rubocop-rails) - Linting for Ruby code.
- [erb-lint](https://github.com/Shopify/erb-lint) - Linting for `.erb` files.
- [Chartkick](https://chartkick.com/) - Chart and graph generation.
- [devise-pwned_password](https://github.com/michaelbanfield/devise-pwned_password) - Gem that checks if Devise Models are using passwords that have shown up in data breaches. Powered by the [pwned](https://github.com/philnash/pwned) gem.
- [Bullet](https://github.com/flyerhzm/bullet) - To ensure database queries are efficient
- [brakeman](https://github.com/presidentbeef/brakeman) - To check for security vulnerabiliies
