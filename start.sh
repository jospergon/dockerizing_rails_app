#!/bin/bash

bundle check || bundle install -j10
bundle exec rails s -b 0.0.0.0
