SET SCRIPT_ROOT=%~dp0
docker volume create node-home
docker volume create node-usr-local-bin
docker volume create node-usr-local-lib-node_modules
docker pull node:latest