@docker volume create rust-rustup
@docker run ^
--rm -it ^
-v %cd%:/usr/src/ ^
-v rust-rustup:/usr/local/rustup/ ^
-w /usr/src/ ^
rust:latest bash %*