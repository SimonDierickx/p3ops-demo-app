#!/bin/bash
set -euo pipefail

echo "kaas1"

# Print environment variables for debugging
env

# Check Docker installation
if ! command -v /usr/bin/docker &> /dev/null; then
    echo "Docker is not installed."
    exit 1
fi

# Pull and run the SQL Server Docker image
/usr/bin/docker pull mcr.microsoft.com/mssql/server:2022-latest
echo "kaas2"
/usr/bin/docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<YourStrong@Passw0rd>" -p 1433:1433 --name sql1 --hostname sql1 -d mcr.microsoft.com/mssql/server:2022-latest
echo "kaas3"

# Check if wget is installed
if ! command -v /usr/bin/wget &> /dev/null; then
    echo "wget is not installed."
    exit 1
fi

# Download the .NET SDK
/usr/bin/wget https://download.visualstudio.microsoft.com/download/pr/18e32a84-60ec-4d82-8ab1-84511be4172b/4a1e6bdd4f15e0d55e0d9bb20c67631e/dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz
echo "kaas4"

# Create directory for .NET SDK
mkdir -p "$HOME/dotnet"
tar zxf dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz -C "$HOME/dotnet" || { echo "Failed to extract .NET SDK"; exit 1; }
echo "kaas5"

# Set environment variables
export DOTNET_ROOT="$HOME/dotnet"
export PATH="$DOTNET_ROOT:$PATH"
echo "kaas6"

# Check if dotnet is available
if ! command -v /usr/bin/dotnet &> /dev/null; then
    echo "dotnet is not installed."
    exit 1
fi

# Run dotnet commands
/usr/bin/dotnet clean
echo "kaas7"
/usr/bin/dotnet restore src/Server/Server.csproj
echo "kaas8"
/usr/bin/dotnet build src/Server/Server.csproj
echo "kaas9"
/usr/bin/dotnet publish src/Server/Server.csproj -c Release -o publish
echo "kaas10"

# Set environment variables for the application
export DOTNET_ENVIRONMENT=Production
export DOTNET_ConnectionStrings__SqlDatabase="Server=localhost,1433;Database=SportStore;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;"
echo "kaas11"

/usr/bin/dotnet publish/Server.dll || { echo "Failed to run the application"; exit 1; }
echo "kaas12"
