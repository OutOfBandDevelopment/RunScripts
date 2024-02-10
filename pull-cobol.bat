SET SCRIPT_ROOT=%~dp0
docker build --tag oobdev/cobol --file %SCRIPT_ROOT%MorePower\DockerFile.gnucobol %SCRIPT_ROOT%