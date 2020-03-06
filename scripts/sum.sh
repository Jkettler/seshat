#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No metric supplied. Useage: sum.sh [metric]"
    exit 1
fi

curl "localhost:4567/metrics/$1/sum"
