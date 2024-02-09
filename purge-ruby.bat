SET SCRIPT_ROOT=%~dp0
docker volume remove ruby-root-local
docker volume remove ruby-usr-local
docker image remove ruby:latest