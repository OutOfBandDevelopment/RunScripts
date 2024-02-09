SET SCRIPT_ROOT=%~dp0
docker build --tag oobdev/google-chrome --file %SCRIPT_ROOT%MorePower\DockerFile.google-chrome %SCRIPT_ROOT%
docker volume create google-chrome-cache
docker volume create google-chrome-config
docker pull oobdev/google-chrome