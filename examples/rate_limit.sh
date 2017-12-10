#!/usr/bin/env bash


# RATE_LIMIT_POLICY_NUMBER_OF_REQUESTS=2 RATE_LIMIT_POLICY_TIME_IN_SECONDS=5 ./bin/rails s

while true; do
  echo  "----------------------------------------------------------------------"
  echo "protected route:"
  curl localhost:3000
  echo -e "\nunprotected route:"
  curl localhost:3000/some-other-route
  echo ""
  sleep 1:
done
