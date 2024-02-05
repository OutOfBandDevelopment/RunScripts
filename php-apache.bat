@REM https://hub.docker.com/_/openjdk
@docker run --rm -it -p 8080:80 -v %cd%:/var/www/html php:7.2-apache 