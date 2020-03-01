#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No value supplied"
    exit 1
fi
curl -X POST -d "value=$1" localhost:4567/metrics/active_visitors
