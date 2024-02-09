SET SCRIPT_ROOT=%~dp0
docker volume remove python-pip-cache
docker volume remove python-pycache
docker image remove python:latest 