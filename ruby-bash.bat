@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat

@docker volume create ruby-root-local >NUL 2>&1
@docker volume create ruby-usr-local  >NUL 2>&1
@docker run --rm -it ^
-v %cd%:/usr/src/ ^
-v ruby-root-local:/root/.local/ ^
-v ruby-usr-local:/usr/local/ ^
-w /usr/src/ ^
-p 8080:8080 %EXTRA_DOCKER_COMMANDS% ^
ruby:latest bash %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %ERRORLEVEL%