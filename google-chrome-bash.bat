@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat
SET SCRIPT_ROOT=%~dp0

docker build -t oobdev/google-chrome -f %SCRIPT_ROOT%MorePower\DockerFile.google-chrome %SCRIPT_ROOT%
docker volume create google-chrome-cache >NUL 2>&1
docker volume create google-chrome-config >NUL 2>&1
docker run --rm -it %EXTRA_DOCKER_COMMANDS% ^
-v %cd%:/root/src ^
-v /run/desktop/mnt/host/wslg/.X11-unix:/tmp/.X11-unix ^
-v /run/desktop/mnt/host/wslg:/mnt/wslg ^
-v google-chrome-cache:/root/.cache/google-chrome ^
-v google-chrome-config:/root/.config/google-chrome %EXTRA_DOCKER_COMMANDS% ^
-w /root/src ^
oobdev/google-chrome bash %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %LAST_ERROR%