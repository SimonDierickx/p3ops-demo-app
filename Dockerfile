# Use .NET 8 SDK for building the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

RUN dnf install -y \
    openssl-libs \
    krb5-libs \
    libicu \
    zlib \
    && dnf clean all

# Copy and restore dependencies
COPY . ./
RUN dotnet restore src/Server/Server.csproj

# Build the project
RUN dotnet publish src/Server/Server.csproj -c Release -o out

# Use .NET 8 Runtime for running the application
FROM almalinux:latest

# Install dependencies for .NET on AlmaLinux

# Copy the build output from the SDK container
WORKDIR /app
COPY --from=build-env /app/out .

# Set environment variables if needed
ENV ASPNETCORE_URLS=http://+:5000

# Expose the port your application will run on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "Server.dll"]
