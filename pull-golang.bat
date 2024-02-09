SET SCRIPT_ROOT=%~dp0
docker volume create go-pkg
docker volume create go-build-cache
docker pull golang:latest