REM https://github.com/pytorch/serve/tree/master/docker
REM https://github.com/pytorch/serve/blob/master/examples/Huggingface_Transformers/README.md

docker run ^
--name torchserve ^
--interactive ^
--tty ^
--volume "%cd%":/current/src/ ^
--workdir /current/src/ ^
--publish 7070:7070 ^
--publish 7071:7071 ^
--publish 8080:8080 ^
--publish 8081:8081 ^
--publish 8082:8082 ^
--gpus all ^
 pytorch/torchserve:latest-gpu %*

IF NOT ERRORLEVEL 0 docker start torchserve
