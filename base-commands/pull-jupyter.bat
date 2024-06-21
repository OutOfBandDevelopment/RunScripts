SET SCRIPT_ROOT=%~dp0
docker build --tag oobdev/jupyter --file %SCRIPT_ROOT%MorePower\DockerFile.jupyter %SCRIPT_ROOT%
docker volume create jupyter-keras-models
docker volume create jupyter-keras-temp
docker volume create jupyter-root
docker volume create jupyter-usr