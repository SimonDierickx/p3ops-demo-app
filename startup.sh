#!/bin/bash
set -euo pipefail

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

docker stop sql1 && docker rm sql1

# Pull and run the SQL Server Docker image
docker pull mcr.microsoft.com/mssql/server:2022-latest
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourStrongPassw0rd" -p 1433:1433 --name sql1 --hostname sql1 -d mcr.microsoft.com/mssql/server:2022-latest

echo "kaas1"
# Remove any existing SDK tarball and download the new one
rm -rf dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz
curl -L -o dotnet-sdk-8.0.403-linux-x64.tar.gz https://download.visualstudio.microsoft.com/download/pr/ca6cd525-677e-4d3a-b66c-11348a6f920a/ec395f498f89d0ca4d67d903892af82d/dotnet-sdk-8.0.403-linux-x64.tar.gz

echo "kaas2"
# Clean up and create a directory for the SDK
rm -rf dotnet
mkdir dotnet

echo "kaas3"
# Extract the SDK tarball
tar zxf dotnet-sdk-8.0.403-linux-x64.tar.gz -C dotnet
echo "kaas4"

# Set environment variables for .NET
export DOTNET_ROOT="$PWD/dotnet"
export PATH="$DOTNET_ROOT:$PATH"

echo "kaas5"
# Run dotnet commands
dotnet clean src/Server/Server.csproj
dotnet restore src/Server/Server.csproj
dotnet build src/Server/Server.csproj
dotnet publish src/Server/Server.csproj -c Release -o publish

# Set the production environment
export DOTNET_ENVIRONMENT=Production
export DOTNET_ConnectionStrings__SqlDatabase="Server=localhost,1433;Database=SportStore;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;"

# Run the published application
dotnet publish/Server.dll
