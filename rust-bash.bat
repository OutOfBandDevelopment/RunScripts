@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat

@docker volume create rust-rustup
@docker run --rm -it ^
-v %cd%:/usr/src/ ^
-v rust-rustup:/usr/local/rustup/ ^
-w /usr/src/ ^
-p 8080:8080 %EXTRA_DOCKER_COMMANDS% ^
rust:latest bash %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %ERRORLEVEL%