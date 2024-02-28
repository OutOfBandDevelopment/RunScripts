
docker build ^
--tag oobdev/sbert ^
--file ..\DockerFile.sbert ^
..

docker run --rm -it ^
-p 5080:5000 ^
oobdev/sbert