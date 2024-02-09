@ECHO OFF
SETLOCAL

IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat"
SET SCRIPT_ROOT=%~dp0

docker volume create go-pkg >NUL 2>&1
docker volume create go-build-cache >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/current/src/ ^
--volume go-pkg:/go/pkg ^
--volume go-build-cache:/root/.cache/go-build ^
--workdir /current/src/ ^
golang:latest bash %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat"

ENDLOCAL
EXIT /B %LAST_ERROR%