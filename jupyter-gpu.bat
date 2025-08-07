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
--tag oobdev/jupyter ^
--file %SCRIPT_ROOT%MorePower\DockerFile.jupyter ^
%SCRIPT_ROOT%
docker volume create jupyter-keras-models >NUL 2>&1
docker volume create jupyter-keras-temp >NUL 2>&1
docker volume create jupyter-root >NUL 2>&1
docker volume create jupyter-usr >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/src/ ^
--volume jupyter-keras-models:/keras ^
--volume jupyter-keras-temp:/tmp/.keras ^
--volume jupyter-root:/root/ ^
--volume jupyter-usr:/usr ^
--workdir /src/ ^
--publish 8888:8888 ^
--gpus all ^
oobdev/jupyter  %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd" %SCRIPT_NAME%
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" %SCRIPT_NAME%

ENDLOCAL
EXIT /B %LAST_ERROR%