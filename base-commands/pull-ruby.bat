SET SCRIPT_ROOT=%~dp0
docker volume create ruby-root-local
docker volume create ruby-usr-local
docker pull ruby:latest