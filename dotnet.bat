@ECHO OFF
SETLOCAL

IF EXIST %CD%\before_docker.cmd CALL %CD%\before_docker.cmd
IF EXIST %CD%\before_docker.bat CALL %CD%\before_docker.bat
SET SCRIPT_ROOT=%~dp0

docker volume create dotnet-root-dotnet >NUL 2>&1
docker volume create dotnet-local-nuget >NUL 2>&1
docker volume create dotnet-nuget >NUL 2>&1
docker run --rm -it %EXTRA_DOCKER_COMMANDS% ^
-v %cd%:/usr/src/ ^
-v dotnet-root-dotnet:/root/.dotnet/ ^
-v dotnet-local-nuget:/root/.local/NuGet/ ^
-v dotnet-nuget:/root/.nuget/ ^
-w /usr/src/ ^
-p 8080:8080 ^
mcr.microsoft.com/dotnet/sdk dotnet %*

SET LAST_ERROR=%ERRORLEVEL%

IF EXIST %CD%\after_docker.cmd CALL %CD%\after_docker.cmd
IF EXIST %CD%\after_docker.bat CALL %CD%\after_docker.bat

ENDLOCAL
EXIT /B %LAST_ERROR%