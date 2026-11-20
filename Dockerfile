FROM ruby:4.0.10-slim-trixie AS build

ENV RUBYOPT='-W:no-deprecated -W:no-experimental'
ENV RAILS_ENV=production

RUN apt update
RUN apt install -y build-essential libsqlite3-dev libyaml-dev

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler

# don't install development, test gems
RUN bundle config set without 'development test'
RUN bundle install --jobs 4 --no-cache --retry 5

COPY . .

# generate master.key and encrypted credentials
RUN EDITOR="mate --wait" bin/rails credentials:edit

RUN bundle exec rails assets:precompile

RUN rails db:setup --trace

# only /usr/local/bundle and /app are copied to the runtime stage so only those need cleaning
RUN rm -rf tmp/cache vendor/assets lib/assets
RUN find /usr/local/bundle /app -type f \( \
      -name "*.c" -o -name "*.h" -o -name "*.hpp" -o -name "*.java" -o \
      -name "*.log" -o -name "*.md" -o -name "*.mk" -o -name "*.o" -o \
      -name "*.txt" -o -name "*.gem" -o -name "Makefile" -o \
      -name "CHANGELOG" -o -name "CHANGES" -o -name "README" -o -name "TODO" -o \
      -name "LICENSE" -o -name "MIT-LICENSE" -o -name "Dockerfile" -o \
      -name ".rspec" -o -name ".rubocop.yml" -o -name "gem_make.out" \
    \) -delete \
 && find /usr/local/bundle /app \( -name "Rakefile" -o -name "spec" \) -prune -exec rm -rf {} +

# Runtime image with only gems and the app
FROM ruby:4.0.10-slim-trixie AS runtime
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /app
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
