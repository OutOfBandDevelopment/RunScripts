@ECHO OFF
SETLOCAL

IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.bat"
IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat"
SET SCRIPT_ROOT=%~dp0
SET WORKING_ROOT=%CD%

docker build ^
--tag oobdev/google-chrome ^
--file %SCRIPT_ROOT%MorePower\DockerFile.google-chrome ^
%SCRIPT_ROOT%
docker volume create google-chrome-cache >NUL 2>&1
docker volume create google-chrome-config >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/current/src/ ^
--volume /run/desktop/mnt/host/wslg/.X11-unix:/tmp/.X11-unix ^
--volume /run/desktop/mnt/host/wslg:/mnt/wslg ^
--volume google-chrome-cache:/root/.cache/google-chrome ^
--volume google-chrome-config:/root/.config/google-chrome %EXTRA_DOCKER_COMMANDS% ^
--workdir /current/src/ ^
oobdev/google-chrome google-chrome --no-sandbox %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat"

ENDLOCAL
EXIT /B %LAST_ERROR%