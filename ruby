#!/bin/bash

if [ -f "$PWD/before_docker.sh" ]; then
    source "$PWD/before_docker.sh"
fi
if [ -f "$PWD/before_docker.sh" ]; then
    source "$PWD/before_docker.sh"
fi

docker volume create create ruby-root-local >/dev/null 2>&1
docker volume create create ruby-usr-local >/dev/null 2>&1
docker run --rm -it \
-v "$(pwd)":/usr/src/ \
-v ruby-root-local:/root/.local/ \
-v ruby-usr-local:/usr/local/ \
-p 8080:8080 $EXTRA_DOCKER_COMMANDS \
-w /usr/src/ \
ruby:latest ruby "$@"

LAST_ERROR=$?

if [ -f "$PWD/after_docker.sh" ]; then
    source "$PWD/after_docker.sh"
fi
if [ -f "$PWD/after_docker.sh" ]; then
    source "$PWD/after_docker.sh"
fi

exit $LAST_ERROR