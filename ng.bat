@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat

@docker volume create node-home.npm >NUL 2>&1
@docker volume create node-usr-local-bin >NUL 2>&1
@docker volume create node-usr-local-lib-node_modules >NUL 2>&1
@docker run --rm -it ^
-v %cd%:/root/src/ ^
-v node-home.npm:/root/.npm/ ^
-v node-usr-local-bin:/usr/local/bin/ ^
-v node-usr-local-lib-node_modules:/usr/local/lib/node_modules/ ^
-w /root/src/ ^
-p 8080:8080 %EXTRA_DOCKER_COMMANDS% ^
node:latest ng %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %LAST_ERROR%