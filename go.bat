@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat

@docker volume create go-pkg >NUL 2>&1
@docker volume create go-build-cache >NUL 2>&1
@docker run --rm -it ^
-v %cd%:/usr/src/ ^
-v go-pkg:/go/pkg ^
-v go-build-cache:/root/.cache/go-build/ ^
-w /usr/src/ ^
-p 8080:8080 ^
golang:latest go %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %ERRORLEVEL%