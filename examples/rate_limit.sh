#!/usr/bin/env bash


# RATE_LIMIT_POLICY_NUMBER_OF_REQUESTS=2 RATE_LIMIT_POLICY_TIME_IN_SECONDS=5 ./bin/rails s

while true; do
  curl localhost:3000
  echo ""
  sleep 1:
  curl localhost:3000/some-other-route | jq
  echo ""
done
