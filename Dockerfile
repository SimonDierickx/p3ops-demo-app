# Use .NET 8 SDK for building the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    openssl \
    krb5-locales \
    libicu-dev \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Copy and restore dependencies
COPY . ./
RUN dotnet restore src/Server/Server.csproj

# Build the project
RUN dotnet publish src/Server/Server.csproj -c Release -o out

# Use .NET 8 Runtime for running the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy the build output from the SDK container
COPY --from=build-env /app/out .

# Set environment variables if needed
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Development

# Expose the port your application will run on
EXPOSE 5000

# Run the application
ENTRYPOINT ["dotnet", "Server.dll"]
