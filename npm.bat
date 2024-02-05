
@echo off
@docker volume create node-home.npm
@docker volume create node-usr-local-bin
@docker volume create node-usr-local-lib-node_modules
@docker run --rm -it ^
-v %cd%:/root/src/ ^
-v node-home.npm:/root/.npm/ ^
-v node-usr-local-bin:/usr/local/bin/ ^
-v node-usr-local-lib-node_modules:/usr/local/lib/node_modules/ ^
-w /root/src/ ^
-p 8080:8080 %EXTRA_DOCKER_COMMANDS% ^
node:latest npm %*
SET LAST_ERROR=%ERRORLEVEL%
EXIT /B %ERRORLEVEL%