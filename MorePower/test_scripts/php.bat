
REM @ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

SET CONTAINER_NAME=php-x

IF EXIST "%CD%\before_docker.cmd" CALL "%CD%\before_docker.cmd" %SCRIPT_NAME%
IF EXIST "%CD%\before_docker.bat" CALL "%CD%\before_docker.bat" %SCRIPT_NAME%
SET SCRIPT_ROOT=%~dp0

IF NOT "%APPLICATION_SET%"=="" (
    SET APPLICATION_SET_END=!APPLICATION_SET:~-1!
    IF NOT "!APPLICATION_SET_END!"=="_" (
        SET APPLICATION_SET=%APPLICATION_SET%_
    )
    SET CONTAINER_NAME=!APPLICATION_SET!!CONTAINER_NAME!
)

IF "%DEBUG%"=="1" ECHO APPLICATION_SET_END=%APPLICATION_SET_END%
IF "%DEBUG%"=="1" ECHO APPLICATION_SET="!APPLICATION_SET!"
IF "%DEBUG%"=="1" ECHO CONTAINER_NAME="%CONTAINER_NAME%"

REM GOTO :EOF

REM check if contaienr is running
docker container inspect %CONTAINER_NAME% --format '{{.Name}}'
IF NOT ERRORLEVEL 0 (
    ECHO run
    docker run %EXTRA_DOCKER_COMMANDS% ^
    --name %CONTAINER_NAME% ^
    --interactive ^
    --tty ^
    --volume "%cd%:/usr/src/" ^
    --workdir "/usr/src/"" ^
    --publish 8080:8080 ^
    php:latest php %*
) ELSE (
    ECHO exec
    docker start %CONTAINER_NAME% 
    docker exec %CONTAINER_NAME% ^
    --interactive ^
    --tty ^
    php %*
    REM docker exec php     --interactive     --tty     php hello_world.php
)

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST "%CD%\after_docker.cmd" CALL "%CD%\after_docker.cmd" %SCRIPT_NAME%
IF EXIST "%CD%\after_docker.bat" CALL "%CD%\after_docker.bat" %SCRIPT_NAME%

:EOF
ENDLOCAL
EXIT /B %LAST_ERROR%