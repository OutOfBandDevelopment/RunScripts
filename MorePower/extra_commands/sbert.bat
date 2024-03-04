
docker build ^
--tag oobdev/sbert ^
--file ..\DockerFile.sbert ^
..

docker run ^
--name sbert ^
-p 5080:5000 ^
oobdev/sbert