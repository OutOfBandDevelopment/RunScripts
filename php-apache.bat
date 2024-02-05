@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat

@docker run --rm -it ^
-v  %cd%:/var/www/html/ ^
-p 8080:80 %EXTRA_DOCKER_COMMANDS% ^
php:7.2-apache %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %ERRORLEVEL%