@ECHO OFF
SETLOCAL

SET SCRIPT_NAME=%~n0

IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" %SCRIPT_NAME%
IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd" %SCRIPT_NAME%
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat" %SCRIPT_NAME%
SET SCRIPT_ROOT=%~dp0
SET WORKING_ROOT=%CD%

docker build ^
--tag oobdev/google-chrome ^
--file %SCRIPT_ROOT%MorePower\DockerFile.google-chrome ^
%SCRIPT_ROOT%
docker volume create google-chrome-cache-dev >NUL 2>&1
docker volume create google-chrome-config-dev >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume "%cd%":/current/src/ ^
--volume /run/desktop/mnt/host/wslg/.X11-unix:/tmp/.X11-unix ^
--volume /run/desktop/mnt/host/wslg:/mnt/wslg ^
--volume google-chrome-cache-dev:/tmp/google-chrome/cache ^
--volume google-chrome-config-dev:/tmp/google-chrome/config %EXTRA_DOCKER_COMMANDS% ^
--workdir /current/src/ ^
--publish 9222:9222 ^
oobdev/google-chrome google-chrome ^
  --remote-debugging-address=0.0.0.0 ^
  --remote-debugging-port=9222 ^
  --no-sandbox ^
  --disable-gpu ^
  --disable-dev-shm-usage ^
  --user-data-dir=/tmp/google-chrome/config ^
  --disable-software-rasterizer ^
  --disable-extensions %*
  
REM  --profile-directory=Default ^

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd" %SCRIPT_NAME%
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" %SCRIPT_NAME%

ENDLOCAL
EXIT /B %LAST_ERROR%