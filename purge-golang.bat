SET SCRIPT_ROOT=%~dp0
docker volume remove go-pkg
docker volume remove go-build-cache
docker image remove golang:latest 