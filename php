#!/bin/bash

if [ -f "$PWD/before_docker.sh" ]; then
    source "$PWD/before_docker.sh"
fi
if [ -f "$PWD/before_docker.sh" ]; then
    source "$PWD/before_docker.sh"
fi

docker run --rm -it \
-v "$(pwd)":/usr/src/ \
-p 8080:8080 $EXTRA_DOCKER_COMMANDS \
-w /usr/src/ \
php:latest php "$@"

LAST_ERROR=$?

if [ -f "$PWD/after_docker.sh" ]; then
    source "$PWD/after_docker.sh"
fi
if [ -f "$PWD/after_docker.sh" ]; then
    source "$PWD/after_docker.sh"
fi

exit $LAST_ERROR