@ECHO OFF
SETLOCAL

IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat"
SET SCRIPT_ROOT=%~dp0

docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/var/www/html/ ^
--workdir /var/www/html/ ^
--publish 8080:80 ^
php:7.2-apache  %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat"

ENDLOCAL
EXIT /B %LAST_ERROR%