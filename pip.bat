@ECHO OFF
SETLOCAL

IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat"
SET SCRIPT_ROOT=%~dp0

docker volume create python-pip-cache >NUL 2>&1
docker volume create python-pycache >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/current/src/ ^
--volume python-pip-cache:/root/.cache/pip/ ^
--volume python-pycache:/usr/local/lib/python3.12/ ^
--workdir /current/src/ ^
python:latest pip %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat"

ENDLOCAL
EXIT /B %LAST_ERROR%