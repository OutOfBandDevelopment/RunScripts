@ECHO OFF
SETLOCAL

IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat"
SET SCRIPT_ROOT=%~dp0

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
oobdev/tensorflow bash %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat"

ENDLOCAL
EXIT /B %LAST_ERROR%