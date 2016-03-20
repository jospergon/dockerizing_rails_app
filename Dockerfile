FROM ruby:2.3.0

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs npm
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g bower

RUN echo '{ "allow_root": true }' > /root/.bowerrc

ENV app /app
RUN mkdir $app
WORKDIR $app

ADD Gemfile* $app/

ENV BUNDLE_GEMFILE=$app/Gemfile \
  BUNDLE_JOBS=10 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . $app
