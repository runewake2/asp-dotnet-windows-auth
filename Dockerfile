#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat 

FROM mcr.microsoft.com/dotnet/framework/sdk:4.7.2 AS build
WORKDIR /app/

# copy csproj and restore as distinct layers
COPY *.sln .
COPY framework/*.csproj ./framework/
COPY framework/*.config ./framework/
RUN nuget restore

# copy everything else and build app
COPY ./framework ./framework
WORKDIR /app/framework
RUN msbuild /p:Configuration=Release


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.7.2 AS runtime
RUN powershell.exe Add-WindowsFeature Web-Windows-Auth
RUN powershell.exe -NoProfile -Command \
  Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/AnonymousAuthentication -name enabled -value false -PSPath IIS:\ ; \
  Set-WebConfigurationProperty -filter /system.webServer/security/authentication/windowsAuthentication -name enabled -value true -PSPath IIS:\ ;
WORKDIR /inetpub/wwwroot
COPY --from=build /app/framework/. ./