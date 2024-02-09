SET SCRIPT_ROOT=%~dp0
docker volume create python-pip-cache
docker volume create python-pycache
docker pull python:latest