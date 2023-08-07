#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

# Use Microsoft's official build .NET image.
# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /app

# Install production dependencies.
# Copy csproj and restore as distinct layers.
COPY *.csproj ./
RUN dotnet restore

# Copy local code to the container image.
COPY . ./
WORKDIR /app

# Build a release artifact.
RUN dotnet publish -c Release -o out


# Use Microsoft's official runtime .NET image.
# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Run the web service on container startup.
ENTRYPOINT ["dotnet", "WebApplication2.dll"]