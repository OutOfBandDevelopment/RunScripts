@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat

@docker run --rm -it ^
-v %cd%:/root/src/ ^
-v %cd%:/usr/src/ ^
-w /usr/src/ ^
-p 8080:8080 %EXTRA_DOCKER_COMMANDS% ^
php:latest php %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %ERRORLEVEL%