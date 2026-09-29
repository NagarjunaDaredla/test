# =========================
# BUILD STAGE
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy solution and project file
COPY EnterpriseApp.sln ./
COPY src/EnterpriseApp.Api/EnterpriseApp.Api.csproj src/EnterpriseApp.Api/

# Restore
RUN dotnet restore src/EnterpriseApp.Api/EnterpriseApp.Api.csproj

# Copy source code
COPY . .

# Build
RUN dotnet build src/EnterpriseApp.Api/EnterpriseApp.Api.csproj \
    --configuration Release \
    --no-restore

# Test
RUN dotnet test EnterpriseApp.sln \
    --configuration Release \
    --no-restore

# Publish
RUN dotnet publish src/EnterpriseApp.Api/EnterpriseApp.Api.csproj \
    --configuration Release \
    --output /app/publish


# =========================
# RUNTIME STAGE
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080

ENTRYPOINT ["dotnet", "EnterpriseApp.Api.dll"]
