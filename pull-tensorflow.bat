SET SCRIPT_ROOT=%~dp0
docker build --tag oobdev/tensorflow --file %SCRIPT_ROOT%MorePower\DockerFile.tensorflow-jupyterlab %SCRIPT_ROOT%
docker volume create tensorflow-keras-models
docker volume create tensorflow-keras-temp
docker volume create tensorflow-root-jupyter
docker volume create tensorflow-root-cache
docker volume create tensorflow-root-ipython
docker volume create tensorflow-root-local
docker volume create tensorflow-usr
docker pull oobdev/tensorflow