SET SCRIPT_ROOT=%~dp0
docker volume create rust-rustup
docker volume create rust-var
docker volume create rust-usr
docker pull rust:latest