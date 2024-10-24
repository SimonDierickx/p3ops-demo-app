#!/bin/bash
set -euo pipefail

docker pull mcr.microsoft.com/mssql/server:2022-latest
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<YourStrong@Passw0rd>" -p 1433:1433 --name sql1 --hostname sql1 -d mcr.microsoft.com/mssql/server:2022-latest
echo kaas1
rm -rf dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz
curl -L -o dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz https://download.visualstudio.microsoft.com/download/pr/18e32a84-60ec-4d82-8ab1-84511be4172b/4a1e6bdd4f15e0d55e0d9bb20c67631e/dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz

echo kaas2
rm -rf dotnet
mkdir dotnet
echo kaas3
tar zxf dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz -C dotnet
echo kaas4
export DOTNET_ROOT=dotnet
export DOTNET_ROOT=dotnet
echo kaas5
dotnet clean
dotnet restore src/Server/Server.csproj
dotnet build src/Server/Server.csproj
dotnet publish src/Server/Server.csproj -c Release -o publish

export DOTNET_ENVIRONMENT=Production
export DOTNET_ConnectionStrings__SqlDatabase="Server=localhost,1433;Database=SportStore;User Id=sa;Password=YourStrongPassw0rd;TrustServerCertificate=True;"

dotnet publish/Server.dll