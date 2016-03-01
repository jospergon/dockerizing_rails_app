FROM ruby:2.3.0

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev

ENV app /app
RUN mkdir $app
ADD Gemfile* $app/
WORKDIR $app
RUN bundle install
ADD . $app

WORKDIR $app
