SET SCRIPT_ROOT=%~dp0
docker volume remove tensorflow-keras-models
docker volume remove tensorflow-keras-temp
docker volume remove tensorflow-root-jupyter
docker volume remove tensorflow-root-cache
docker volume remove tensorflow-root-ipython
docker volume remove tensorflow-root-local
docker volume remove tensorflow-usr
docker image remove oobdev/tensorflow