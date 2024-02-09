SET SCRIPT_ROOT=%~dp0
docker volume create tensorflow-keras-models
docker volume create tensorflow-keras-temp
docker volume create tensorflow-root
docker volume create tensorflow-usr
docker pull intel/intel-optimized-tensorflow