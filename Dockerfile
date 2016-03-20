FROM ruby:2.3.0

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev npm
RUN npm install -g bower

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install -j10

ENV app /app
RUN mkdir $app
WORKDIR $app
ADD . $app

WORKDIR $app
