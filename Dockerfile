FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY EnterpriseApp.sln .
COPY src/EnterpriseApp.Api/EnterpriseApp.Api.csproj src/EnterpriseApp.Api/
COPY tests/EnterpriseApp.Api.Tests/EnterpriseApp.Api.Tests.csproj tests/EnterpriseApp.Api.Tests/
RUN dotnet restore EnterpriseApp.sln
COPY . .
RUN dotnet test EnterpriseApp.sln --configuration Release --no-restore
RUN dotnet publish src/EnterpriseApp.Api/EnterpriseApp.Api.csproj --configuration Release --no-restore --output /app/publish
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
COPY --from=build /app/publish .
USER app
ENTRYPOINT ["dotnet", "EnterpriseApp.Api.dll"]
