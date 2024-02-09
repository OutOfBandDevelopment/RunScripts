SET SCRIPT_ROOT=%~dp0
docker volume remove rust-rustup
docker image remove rust:latest 