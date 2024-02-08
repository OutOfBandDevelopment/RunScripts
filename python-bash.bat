@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat
SET SCRIPT_ROOT=%~dp0

docker volume create python-pip-cache >NUL 2>&1
docker volume create python-pycache >NUL 2>&1
docker run --rm -it %EXTRA_DOCKER_COMMANDS% ^
-v %cd%:/usr/src/ ^
-v python-pip-cache:/root/.cache/pip/ ^
-v python-pycache:/usr/local/lib/python3.12/ ^
-w /usr/src/ ^
python:latest bash %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %LAST_ERROR%