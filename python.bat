@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat

@docker volume create python-pip-cache >NUL 2>&1
@docker volume create python-pycache >NUL 2>&1
@docker run --rm -it ^
-v %cd%:/usr/src/ ^
-v python-pip-cache:/root/.cache/pip/ ^
-v python-__pycache__:/usr/local/lib/python3.12/ ^
-p 8080:8080 %EXTRA_DOCKER_COMMANDS% ^
-w /usr/src/ ^
python:latest python %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %LAST_ERROR%