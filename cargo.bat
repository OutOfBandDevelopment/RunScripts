@docker volume create rust-rustup
@docker run ^
--rm -it ^
-v %cd%:/usr/src/ ^
-v rust-rustup:/usr/local/rustup/ ^
-w /usr/src/ ^
-p 8080:8080 %EXTRA_DOCKER_COMMANDS% ^
rust:latest cargo %*