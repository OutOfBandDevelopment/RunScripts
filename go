#!/bin/bash

if [ -f "$PWD/before_docker.sh" ]; then
    source "$PWD/before_docker.sh"
fi
if [ -f "$PWD/before_docker.sh" ]; then
    source "$PWD/before_docker.sh"
fi

docker volume create create go-pkg >/dev/null 2>&1
docker volume create create go-build-cache >/dev/null 2>&1
docker run --rm -it \
-v "$(pwd)":/usr/src/ \
-v go-pkg:/go/pkg \
-v go-build-cache:/root/.cache/go-build/ \
-p 8080:8080 $EXTRA_DOCKER_COMMANDS \
-w /usr/src/ \
golang:latest go "$@"

LAST_ERROR=$?

if [ -f "$PWD/after_docker.sh" ]; then
    source "$PWD/after_docker.sh"
fi
if [ -f "$PWD/after_docker.sh" ]; then
    source "$PWD/after_docker.sh"
fi

exit $LAST_ERROR