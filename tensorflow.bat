@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat
SET SCRIPT_ROOT=%~dp0

docker build -t oobdev/tensorflow -f %SCRIPT_ROOT%MorePower\DockerFile.tensorflow-jupyterlab %SCRIPT_ROOT%
docker volume create tensorflow-keras-models >NUL 2>&1
docker volume create tensorflow-keras-temp >NUL 2>&1
docker volume create tensorflow-root-jupyter >NUL 2>&1
docker volume create tensorflow-root-cache >NUL 2>&1
docker volume create tensorflow-root-ipython >NUL 2>&1
docker volume create tensorflow-root-local >NUL 2>&1
docker volume create tensorflow-usr >NUL 2>&1
docker run --rm -it %EXTRA_DOCKER_COMMANDS% ^
-v %cd%:/tensorflow/src ^
-v tensorflow-keras-models:/keras ^
-v tensorflow-keras-temp:/tmp/.keras ^
-v tensorflow-root-jupyter:/root/.jupyter ^
-v tensorflow-root-cache:/root/.cache ^
-v tensorflow-root-ipython:/root/.ipython ^
-v tensorflow-root-local:/root/.local ^
-v tensorflow-usr:/usr ^
-w /tensorflow/src ^
-p 8888:8888 ^
oobdev/tensorflow  %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %LAST_ERROR%