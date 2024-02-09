@ECHO OFF
SETLOCAL

IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat"
SET SCRIPT_ROOT=%~dp0

docker volume create node-home >NUL 2>&1
docker volume create node-usr-local-bin >NUL 2>&1
docker volume create node-usr-local-lib-node_modules >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/current/src/ ^
--volume node-home:/root/ ^
--volume node-usr-local-bin:/usr/local/bin/ ^
--volume node-usr-local-lib-node_modules:/usr/local/lib/node_modules/ ^
--workdir /current/src/ ^
node:latest ts-node %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat"

ENDLOCAL
EXIT /B %LAST_ERROR%