# Start from a basic AlmaLinux image
FROM almalinux:latest

# Install necessary packages and .NET 8.0 SDK
RUN dnf update -y && \
    dnf install -y dotnet-sdk-8.0 \
    && dnf clean all

# Set up environment variables for .NET
ENV DOTNET_ROOT=/usr/lib64/dotnet
ENV PATH="$PATH:/usr/lib64/dotnet"

# Copy your .NET application files to the Docker container
WORKDIR /app
COPY . .

# Restore dependencies, build, and publish the application
RUN dotnet restore
RUN dotnet build -c Release
RUN dotnet publish -c Release -o /app/publish

# Expose the port (if needed)
EXPOSE 5000

# ENV
ENV ConnectionStrings__DefaultConnection="Server=localhost,1433;Database=SportStore;User Id=sa;Password=YourStrong@Passw0rd;"


# Run the application
ENTRYPOINT ["dotnet", "/app/publish/Server.dll"]
