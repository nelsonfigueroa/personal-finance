FROM ruby:3.2.3-alpine3.19 AS build

ENV RUBYOPT='-W:no-deprecated -W:no-experimental'
ENV RAILS_ENV=production

RUN apk --update add build-base gcompat sqlite-dev nodejs npm yaml-dev

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler

# don't install development, test gems
RUN bundle config set without 'development test'
RUN bundle install --jobs 4 --no-cache --retry 5

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

RUN bundle exec rails tailwindcss:install && bundle exec rails assets:precompile

RUN rails db:setup --trace

# I don't think I need these?
RUN apk del nodejs
RUN apk del npm
RUN apk del build-base

# cleanup
RUN rm -rf tmp/cache vendor/assets lib/assets /usr/local/share/.cache /var/cache/apk/* /root/.bundle/cache
RUN find / -type f -name "*.c" -exec rm -rf {} +
RUN find / -type f -name "*.h" -exec rm -rf {} +
RUN find / -type f -name "*.hpp" -exec rm -rf {} +
RUN find / -type f -name "*.java" -exec rm -rf {} +
RUN find / -type f -name "*.log" -exec rm -rf {} +
RUN find / -type f -name "*.md" -exec rm -rf {} +
RUN find / -type f -name "*.mk" -exec rm -rf {} +
RUN find / -type f -name "*.o" -exec rm -rf {} +
RUN find / -type f -name "*.txt" -exec rm -rf {} +
RUN find / -type f -name "Makefile" -exec rm -rf {} +
RUN find / -type f -name "*.gem" -exec rm -rf {} +
RUN find / -type f -name "CHANGELOG" -exec rm -rf {} +
RUN find / -type f -name "LICENSE" -exec rm -rf {} +
RUN find / -type f -name "README" -exec rm -rf {} +
RUN find / -type f -name "CHANGES" -exec rm -rf {} +
RUN find / -type f -name "TODO" -exec rm -rf {} +
RUN find / -type f -name "MIT-LICENSE" -exec rm -rf {} +
RUN find / -type f -name "Dockerfile" -exec rm -rf {} +
RUN find / -type f -name ".rspec" -exec rm -rf {} +
RUN find / -type f -name ".rubocop.yml" -exec rm -rf {} +
RUN find / -type f -name "gem_make.out" -exec rm -rf {} +
RUN find / -name ".npm" -exec rm -rf {} +
RUN find / -name "Rakefile" -exec rm -rf {} +
RUN find / -name "spec" -exec rm -rf {} +
RUN find / -name "node_modules" -exec rm -rf {} +

# remove the package manager
RUN apk del apk-tools

# Runtime image without deleted files/directories
FROM ruby:3.2.3-alpine3.19 AS runtime
COPY --from=build . .

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /app
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
