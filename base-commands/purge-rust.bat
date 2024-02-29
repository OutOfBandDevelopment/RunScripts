SET SCRIPT_ROOT=%~dp0
docker volume remove rust-rustup
docker volume remove rust-var
docker volume remove rust-usr
docker image remove rust:latest