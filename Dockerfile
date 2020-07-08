FROM ruby:2.7.1-alpine3.11

ARG RUBYOPT='-W:no-deprecated -W:no-experimental'
ENV RUBYOPT=$RUBYOPT
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

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

# don't install development gems
# RUN bundle install
RUN bundle install --without development
# RUN bundle install --without development test

COPY . .

RUN yarn install --check-files
RUN RAILS_ENV=production bundle exec rails assets:precompile


# RUN rails db:migrate
# RUN rails db:seed

# EXPOSE 3000
# CMD ["rails", "s", "-b", "0.0.0.0"]