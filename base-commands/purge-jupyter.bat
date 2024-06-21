SET SCRIPT_ROOT=%~dp0
docker volume remove jupyter-keras-models
docker volume remove jupyter-keras-temp
docker volume remove jupyter-root
docker volume remove jupyter-usr
docker image remove oobdev/jupyter