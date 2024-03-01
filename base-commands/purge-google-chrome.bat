SET SCRIPT_ROOT=%~dp0
docker volume remove google-chrome-cache
docker volume remove google-chrome-config
docker image remove oobdev/google-chrome