FROM ruby:2.4

ENV DEBIAN_FRONTEND noninteractive
ENV RAILS_ENV production

RUN apt-get update \
 && apt-get install -y --no-install-recommends postgresql-client locales ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && echo "ru_RU.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen ru_RU.UTF-8 \
 && dpkg-reconfigure locales \
 && /usr/sbin/update-locale LANG=ru_RU.UTF-8

COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock
RUN (cd /tmp && bundle install)

EXPOSE 3000
ADD startup.sh /startup.sh
CMD ["/startup.sh"]