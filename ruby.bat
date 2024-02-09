@ECHO OFF
SETLOCAL

IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat"
SET SCRIPT_ROOT=%~dp0

docker volume create ruby-root-local >NUL 2>&1
docker volume create ruby-usr-local >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/current/src/ ^
--volume ruby-root-local:/root/.local/ ^
--volume ruby-usr-local:/usr/local/ ^
--workdir /current/src/ ^
ruby:latest ruby %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat"

ENDLOCAL
EXIT /B %LAST_ERROR%