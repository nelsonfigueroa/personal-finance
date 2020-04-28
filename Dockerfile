FROM ruby:2.7.1-alpine3.11

ARG RUBYOPT='-W:no-deprecated -W:no-experimental'
ENV RUBYOPT=$RUBYOPT

RUN apk update

# for nokogiri
RUN apk add build-base
# postgres
RUN apk add postgresql-dev
# for webpacker
RUN apk add yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.1.4
RUN bundle install

COPY . .

RUN yarn install --check-files
RUN bundle exec rails assets:precompile

# RUN rails db:migrate
# RUN rails db:seed

# EXPOSE 3000
# CMD ["rails", "s", "-b", "0.0.0.0"]