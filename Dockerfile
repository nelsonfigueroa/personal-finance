FROM ruby:3.2.3-alpine3.19

ARG RUBYOPT='-W:no-deprecated -W:no-experimental'
ENV RUBYOPT=$RUBYOPT
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

RUN apk update

RUN apk add build-base
RUN apk add gcompat
RUN apk add sqlite-dev
RUN apk add nodejs npm
# to fix "warning: It seems your ruby installation is missing psych (for YAML output)"
RUN apk add yaml-dev

RUN rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler

# don't install development, test gems
RUN bundle config set without 'development test'
RUN bundle install

# workaround to fix some SQLite issues
RUN gem uninstall sqlite3
RUN gem install sqlite3 --platform=ruby

RUN rm -rf /usr/local/bundle/cache/*.gem \
	&& find /usr/local/bundle/gems/ -name "*.c" -delete \
       && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . .

RUN npm install

# generate master.key and encrypted credentials
RUN EDITOR="mate --wait" bin/rails credentials:edit

RUN bundle exec rails tailwindcss:install
RUN bundle exec rails assets:precompile

# these aren't needed after assets are precompiled
RUN rm -rf node_modules tmp/cache vendor/assets lib/assets spec /usr/local/share/.cache

RUN rails db:create --trace
RUN rails db:migrate
RUN rails db:seed

EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0"]
