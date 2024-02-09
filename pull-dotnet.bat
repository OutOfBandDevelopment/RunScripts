SET SCRIPT_ROOT=%~dp0
docker volume create dotnet-root-dotnet
docker volume create dotnet-local-nuget
docker volume create dotnet-nuget
docker pull mcr.microsoft.com/dotnet/sdk