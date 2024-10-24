#!/bin/bash
set -euo pipefail

# Pull and run the SQL Server Docker image
docker pull mcr.microsoft.com/mssql/server:2022-latest
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<YourStrong@Passw0rd>" -p 1433:1433 --name sql1 --hostname sql1 -d mcr.microsoft.com/mssql/server:2022-latest

echo "kaas1"
# Remove any existing SDK tarball and download the new one
rm -rf dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz
curl -L -o dotnet-sdk-8.0.403-linux-x64.tar.gz https://download.visualstudio.microsoft.com/download/pr/9b682e2e-5f0e-48b4-b8b1-0e29c3b5e96d/2a1b8a5baff2e64111373559151dc606/dotnet-sdk-8.0.403-linux-x64.tar.gz

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
