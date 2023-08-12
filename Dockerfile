FROM ruby:3.1.3-alpine

ARG RUBYOPT='-W:no-deprecated -W:no-experimental'
ENV RUBYOPT=$RUBYOPT
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# to be able to run destructive database commands in production
ENV DISABLE_DATABASE_ENVIRONMENT_CHECK=1

RUN apk update

# for nokogiri
RUN apk add build-base
# RUN apk add gcompat
# RUN apk add libstdc++
# postgres
RUN apk add postgresql-dev
# for webpacker
RUN apk add yarn
RUN rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.3.7

# don't install development, test gems
RUN bundle config set without 'development test'
RUN bundle install

RUN rm -rf /usr/local/bundle/cache/*.gem \
	&& find /usr/local/bundle/gems/ -name "*.c" -delete \
	&& find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . .

RUN yarn install --check-files

# generate master.key and encrypted credentials
RUN EDITOR="mate --wait" bin/rails credentials:edit

RUN bundle exec rails assets:precompile

# these aren't needed after assets are precompiled
RUN rm -rf node_modules tmp/cache vendor/assets lib/assets spec

# more yarn caches
RUN rm -rf /usr/local/share/.cache

# RUN rails db:migrate
# RUN rails db:seed

EXPOSE 3000
# CMD ["rails", "s", "-b", "0.0.0.0"]