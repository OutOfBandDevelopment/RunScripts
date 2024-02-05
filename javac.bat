@REM https://hub.docker.com/_/openjdk
@docker run --rm -it -v %cd%:/usr/src/ -w /usr/src/ openjdk:latest javac %*