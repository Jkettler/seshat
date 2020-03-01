#!/usr/bin/env bash
bundle install && docker-compose up -d && ruby seshat.rb
