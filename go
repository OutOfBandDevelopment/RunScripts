#!/bin/bash

if [ -e "$HOME/.oobdev/RunScripts/before_all.sh" ]; then
    . "$HOME/.oobdev/RunScripts/before_all.sh"
fi
if [ -e "$PWD/before_docker.sh" ]; then
    source "$PWD/before_docker.sh"
fi

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export SCRIPT_ROOT
WORKING_ROOT=$(pwd)
export WORKING_ROOT

docker volume create go-pkg > /dev/null 2>&1
docker volume create go-build-cache > /dev/null 2>&1
docker run --rm $EXTRA_DOCKER_COMMANDS \
--interactive \
--tty \
--volume $PWD:/current/src/ \
--volume go-pkg:/go/pkg \
--volume go-build-cache:/root/.cache/go-build \
--workdir /current/src/ \
golang:latest go $@

LAST_ERROR=$?

if [ -e "$PWD/after_docker.sh" ]; then
    source "$PWD/after_docker.sh"
fi
if [ -e "$HOME/.oobdev/RunScripts/after_docker.sh" ]; then
    . "$HOME/.oobdev/RunScripts/after_docker.sh"
fi

exit $LAST_ERROR