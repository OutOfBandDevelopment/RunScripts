
docker build ^
--tag oobdev/jupyter ^
--file ..\DockerFile.jupyter ^
..

docker run --rm %EXTRA_DOCKER_COMMANDS% ^
--interactive ^
--tty ^
--volume %cd%:/jupyter/src/ ^
--workdir /jupyter/src/ ^
--publish 8888:8888 ^
oobdev/jupyter  %*