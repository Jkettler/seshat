#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No metric supplied. Usage: post.sh [metric] [value]"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No value supplied. Usage: post.sh [metric] [value]"
    exit 1
fi
curl -X POST -d "value=$2" "localhost:4567/metrics/$1"

#curl "localhost:4567/metrics/some_other_metric/sum"
#curl -X POST -d "value=15" "localhost:4567/metrics/some_other_metric"


