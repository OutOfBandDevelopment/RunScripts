SET SCRIPT_ROOT=%~dp0
docker volume remove dotnet-root-dotnet
docker volume remove dotnet-local-nuget
docker volume remove dotnet-nuget
docker image remove mcr.microsoft.com/dotnet/sdk