#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No metric supplied. Useage: post.sh [metric] [value]"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No value supplied. Useage: post.sh [metric] [value]"
    exit 1
fi
curl -X POST -d "value=$2" "localhost:4567/metrics/$1"

