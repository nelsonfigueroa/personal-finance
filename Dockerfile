FROM ruby:2.6.5-alpine3.11

# for nokogiri
RUN apk add build-base
# postgres
RUN apk add postgresql-dev
# for webpacker
RUN apk add yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.0.1

# for some reason it's still using older version to install, specify version
RUN bundle _2.0.1_ install

COPY . .

RUN yarn install --check-files
RUN bundle exec rails assets:precompile

# RUN rails db:migrate
# RUN rails db:seed

# EXPOSE 3000
# CMD ["rails", "s", "-b", "0.0.0.0"]