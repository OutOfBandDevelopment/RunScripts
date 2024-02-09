SET SCRIPT_ROOT=%~dp0
docker volume remove tensorflow-keras-models
docker volume remove tensorflow-keras-temp
docker volume remove tensorflow-root
docker volume remove tensorflow-usr
docker image remove intel/intel-optimized-tensorflow