FROM ruby:2.4

RUN apt-get update \
 && apt-get install -y --no-install-recommends postgresql-client \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY . .
RUN bundle install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]