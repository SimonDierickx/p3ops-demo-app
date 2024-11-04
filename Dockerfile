# Start from a basic AlmaLinux image
FROM almalinux:latest

# Install necessary packages and .NET 8.0 SDK
RUN dnf update -y && \
    dnf install -y dotnet-sdk-8.0 && \
    dnf clean all

# Set up environment variables for .NET
ENV PATH="$PATH:/usr/lib64/dotnet"

# Set the working directory for the application
WORKDIR /app

# Copy your .NET application files to the Docker container
COPY . .

# Restore dependencies
RUN dotnet restore

# Build and publish the application
RUN dotnet build -c Release
RUN dotnet publish -c Release -o /app/publish

# Expose the port (adjust if different)
EXPOSE 5000

# Environment variables (ensure they match your app configuration)
ENV ConnectionStrings__DefaultConnection="Server=localhost,1433;Database=SportStore;User Id=sa;Password=YourStrong@Passw0rd;"

# Run the application with ENTRYPOINT, correcting the DLL path if needed
ENTRYPOINT ["dotnet", "/app/publish/Server.dll"]
