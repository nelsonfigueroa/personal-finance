FROM ruby:3.3.1-slim-bullseye AS build

ENV RUBYOPT='-W:no-deprecated -W:no-experimental'
ENV RAILS_ENV=production

RUN apt update
RUN apt install -y build-essential npm libsqlite3-dev nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler

# don't install development, test gems
RUN bundle config set without 'development test'
RUN bundle install --jobs 4 --no-cache --retry 5

COPY . .

RUN npm install

# generate master.key and encrypted credentials
RUN EDITOR="mate --wait" bin/rails credentials:edit

RUN bundle exec rails tailwindcss:install && bundle exec rails assets:precompile

RUN rails db:setup --trace

# cleanup
RUN apt remove -y nodejs
RUN apt remove -y build-essential
RUN apt autoremove -y

# more cleanup
RUN rm -rf tmp/cache vendor/assets lib/assets /usr/local/share/.cache /root/.bundle/cache
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
RUN apt remove -y --allow-remove-essential apt

# Runtime image without unnecessary files/directories
FROM ruby:3.3.1-slim-bullseye AS runtime
COPY --from=build . .

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /app
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
