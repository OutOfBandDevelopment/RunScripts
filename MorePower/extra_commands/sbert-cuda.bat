
docker build ^
--tag oobdev/sbert ^
--file ..\DockerFile.sbert-cuda ^
..

docker run ^
--name sbert ^
-p 5080:5000 ^
--gpus all ^
oobdev/sbert


REM curl http://127.0.0.1:5080/generate-embedding?query=helloworld