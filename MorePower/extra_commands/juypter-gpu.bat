
docker build ^
--tag oobdev/jupyter ^
--file ..\DockerFile.jupyter ^
..

IF NOT ERRORLEVEL 0 GOTO :EOF

docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/jupyter/src/ ^
--workdir /jupyter/src/ ^
--publish 8888:8888 ^
--gpus all ^
oobdev/jupyter  %*