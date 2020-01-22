#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-nanoserver-1809 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-nanoserver-1809 AS build
WORKDIR /src
COPY ["core/Active Directory .netcore.csproj", "core/"]
RUN dotnet restore "core/Active Directory .netcore.csproj"
COPY . .
WORKDIR "/src/core"
RUN dotnet build "Active Directory .netcore.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Active Directory .netcore.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Active Directory .netcore.dll"]