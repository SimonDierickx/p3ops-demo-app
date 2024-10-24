#!/bin/bash

# Update the package index
apt-get update -y

# Install Docker and wget using apt-get
apt-get install -y docker.io wget

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Pull the latest SQL Server Docker image
docker pull mcr.microsoft.com/mssql/server:2022-latest

# Run the SQL Server container
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourStrongPassw0rd" -p 1433:1433 --name sql1 --hostname sql1 -d mcr.microsoft.com/mssql/server:2022-latest

# Download .NET SDK for the appropriate architecture
wget https://download.visualstudio.microsoft.com/download/pr/18e32a84-60ec-4d82-8ab1-84511be4172b/4a1e6bdd4f15e0d55e0d9bb20c67631e/dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz

# Create directory for dotnet and extract the SDK
mkdir -p $HOME/dotnet
tar zxf dotnet-sdk-8.0.403-linux-musl-arm64.tar.gz -C $HOME/dotnet

# Set environment variables for .NET SDK
export DOTNET_ROOT=$HOME/dotnet
export PATH=$PATH:$HOME/dotnet

# Navigate to the project directory
cd p3ops-demo-app

# Clean, restore, build, and publish the application
dotnet clean
dotnet restore src/Server/Server.csproj
dotnet build src/Server/Server.csproj
dotnet publish src/Server/Server.csproj -c Release -o publish

# Set environment variables for the application
export DOTNET_ENVIRONMENT=Production
export DOTNET_ConnectionStrings__SqlDatabase="Server=localhost,1433;Database=SportStore;User Id=sa; Password=YourStrongPassw0rd;TrustServerCertificate=True;"

# Run the application
dotnet publish/Server.dll
