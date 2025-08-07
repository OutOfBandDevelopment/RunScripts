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
--tag oobdev/tensorflow ^
--file %SCRIPT_ROOT%MorePower\DockerFile.tensorflow-jupyterlab ^
%SCRIPT_ROOT%
docker volume create tensorflow-keras-models >NUL 2>&1
docker volume create tensorflow-keras-temp >NUL 2>&1
docker volume create tensorflow-root-jupyter >NUL 2>&1
docker volume create tensorflow-root-cache >NUL 2>&1
docker volume create tensorflow-root-ipython >NUL 2>&1
docker volume create tensorflow-root-local >NUL 2>&1
docker volume create tensorflow-usr >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/tensorflow/src/ ^
--volume tensorflow-keras-models:/keras ^
--volume tensorflow-keras-temp:/tmp/.keras ^
--volume tensorflow-root-jupyter:/root/.jupyter ^
--volume tensorflow-root-cache:/root/.cache ^
--volume tensorflow-root-ipython:/root/.ipython ^
--volume tensorflow-root-local:/root/.local ^
--volume tensorflow-usr:/usr ^
--workdir /tensorflow/src/ ^
--publish 8888:8888 ^
oobdev/tensorflow  %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd" %SCRIPT_NAME%
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" %SCRIPT_NAME%
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" %SCRIPT_NAME%

ENDLOCAL
EXIT /B %LAST_ERROR%