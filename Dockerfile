FROM ruby:2.3.0

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs npm
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g bower

RUN echo '{ "allow_root": true }' > /root/.bowerrc

ENV app /app
RUN mkdir $app
WORKDIR $app

ENV BUNDLE_PATH /bundle

WORKDIR $app
ADD . $app
