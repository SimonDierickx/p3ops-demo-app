#!/bin/bash
echo kaas1

docker pull mcr.microsoft.com/mssql/server:2022-latest
echo kaas2
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<YourStrong@Passw0rd>" -p 1433:1433 --name sql1 --hostname sql1 -d  mcr.microsoft.com/mssql/server:2022-latest
echo kaas3
wget https://download.visualstudio.microsoft.com/download/pr/18e32a84-60ec-4d82-8ab1-84511be4172b/4a1e6bdd4f15e0d55e0d9bb20c67631e/dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz
echo kaas4
mkdir -p $HOME/dotnet
tar zxf dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz -C $HOME/dotnet
echo kaas5
export DOTNET_ROOT=$HOME/dotnet
export DOTNET_ROOT=$HOME/dotnet
echo kaas6
dotnet clean
echo kaas7
dotnet restore src/Server/Server.csproj
echo kaas8
dotnet build src/Server/Server.csproj
echo kaas9
dotnet publish src/Server/Server.csproj -c Release -o publish
echo kaas10

export DOTNET_ENVIRONMENT=Production
export DOTNET_ConnectionStrings__SqlDatabase="Server=localhost,1433;Database=SportStore;User Id=sa; Password=YourStrongPassw0rd;TrustServerCertificate=True;"
echo kaas11
dotnet publish/Server.dll
echo kaas12