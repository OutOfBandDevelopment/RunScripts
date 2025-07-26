@ECHO OFF
SETLOCAL

IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" "%~nx0"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" "%~nx0"
IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd" "%~nx0"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat" "%~nx0"
SET SCRIPT_ROOT=%~dp0
SET WORKING_ROOT=%CD%
SET DOCKER_COMPOSE_SCRIPT=%SCRIPT_ROOT%MorePower\docker-compose.devbox.yml
IF "%PROJECT_NAME%"=="" SET PROJECT_NAME=devbox
IF "%PROJECT_SERVICE%"=="" SET PROJECT_SERVICE=devbox

SET HOST_PWD=%WORKING_ROOT%
ECHO WEB_PORT=%WEB_PORT%
CALL docker-compose ^
    --project-name %PROJECT_NAME% ^
    --file "%DOCKER_COMPOSE_SCRIPT%" ^
    run ^
    --rm ^
    --env HOST_PWD=%HOST_PWD% ^
    --service-ports ^
    %PROJECT_SERVICE%  %EXTRA_DOCKER_COMMANDS%

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd" "%~nx0"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat" "%~nx0"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" "%~nx0"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" "%~nx0"

ENDLOCAL
EXIT /B %LAST_ERROR%
