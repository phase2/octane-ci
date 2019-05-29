#!/usr/bin/env bash

# In GitLab's shared runners it seems docker is pulled in via
# volume mounting the socket at times rather than as a tcp connection.
# This looks to see if the socket exists and if it doesn't, sets
# the DOCKER_HOST variable (needed on our runner's) if it isn't already
# set.

if [ ! -e /var/run/docker.sock ]; then
  if [ -z "${DOCKER_HOST}" ]; then
    export DOCKER_HOST="tcp://localhost:2375"
  fi
else
  export DOCKER_HOST_DEBUG="Socket was observed to exist"
fi
