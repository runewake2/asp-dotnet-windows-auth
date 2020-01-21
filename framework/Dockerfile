# Dockerize .NET Framework - ASP.NET MVC application
# Create an image to build from source
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]