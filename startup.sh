#!/bin/bash
set -euo pipefail
echo "kaas1"

unset DOTNET_SYSTEM_GLOBALIZATION_INVARIANT

echo "kaas1"
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
echo "kaas2"

docker stop sql1 && docker rm sql1

# Pull and run the SQL Server Docker image
echo "kaas3"
docker pull mcr.microsoft.com/mssql/server:2022-latest
echo "kaas4"
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourStrongPassw0rd" -p 1433:1433 --name sql1 --hostname sql1 -d mcr.microsoft.com/mssql/server:2022-latest

echo "kaas5"
# Remove any existing SDK tarball and download the new one
rm -rf dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz
echo "kaas6"
curl -L -o dotnet-sdk-8.0.403-linux-x64.tar.gz https://download.visualstudio.microsoft.com/download/pr/ca6cd525-677e-4d3a-b66c-11348a6f920a/ec395f498f89d0ca4d67d903892af82d/dotnet-sdk-8.0.403-linux-x64.tar.gz
echo "kaas7"

# Clean up and create a directory for the SDK
rm -rf dotnet
echo "kaas8"
mkdir dotnet
echo "kaas9"

# Extract the SDK tarball
tar zxf dotnet-sdk-8.0.403-linux-x64.tar.gz -C dotnet
echo "kaas10"

# Set environment variables for .NET
export DOTNET_ROOT="$PWD/dotnet"
echo "kaas11"
export PATH="$DOTNET_ROOT:$PATH"

echo "kaas12"
# Run dotnet commands
dotnet clean src/Server/Server.csproj
echo "kaas13"
dotnet restore src/Server/Server.csproj
echo "kaas14"
dotnet build src/Server/Server.csproj
echo "kaas15"
dotnet publish src/Server/Server.csproj -c Release -o publish
echo "kaas16"

# Set the production environment
export DOTNET_ENVIRONMENT=Production
echo "kaas17"
export DOTNET_ConnectionStrings__SqlDatabase="Server=localhost,1433;Database=SportStore;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;"
echo "kaas18"
# Run the published application
#dotnet publish/Server.dll
