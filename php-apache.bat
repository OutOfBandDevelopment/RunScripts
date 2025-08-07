@ECHO OFF
SETLOCAL

SET SCRIPT_NAME=%~n0

IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" %SCRIPT_NAME%
IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd" %SCRIPT_NAME%
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat" %SCRIPT_NAME%
SET SCRIPT_ROOT=%~dp0
SET WORKING_ROOT=%CD%

docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/var/www/html/ ^
--workdir /var/www/html/ ^
--publish 8080:80 ^
php:7.2-apache  %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd" %SCRIPT_NAME%
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" %SCRIPT_NAME%

ENDLOCAL
EXIT /B %LAST_ERROR%