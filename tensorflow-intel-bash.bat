@ECHO OFF
SETLOCAL

IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.cmd"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\before_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\before_all.bat"
IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd"
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat"
SET SCRIPT_ROOT=%~dp0
SET WORKING_ROOT=%CD%

docker volume create tensorflow-keras-models >NUL 2>&1
docker volume create tensorflow-keras-temp >NUL 2>&1
docker volume create tensorflow-root >NUL 2>&1
docker volume create tensorflow-usr >NUL 2>&1
docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/tensorflow/src/ ^
--volume tensorflow-keras-models:/keras/ ^
--volume tensorflow-keras-temp:/tmp/.keras/ ^
--volume tensorflow-root:/root/ ^
--volume tensorflow-usr:/usr/ ^
--workdir /tensorflow/src/ ^
intel/intel-optimized-tensorflow bash %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd"
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.cmd"
IF EXIST "%USERPROFILE%\.oobdev\RunScripts\after_all.bat" CALL "%USERPROFILE%\.oobdev\RunScripts\after_all.bat"

ENDLOCAL
EXIT /B %LAST_ERROR%