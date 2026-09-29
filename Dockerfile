# =========================
# BUILD STAGE
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy solution and project files
COPY EnterpriseApp.sln ./
COPY src/EnterpriseApp.Api/EnterpriseApp.Api.csproj src/EnterpriseApp.Api/

# Restore dependencies
RUN dotnet restore EnterpriseApp.sln

# Copy remaining source code
COPY . .

# Build
RUN dotnet build EnterpriseApp.sln \
    --configuration Release \
    --no-restore

# Run tests
RUN dotnet test EnterpriseApp.sln \
    --configuration Release \
    --no-build \
    --no-restore

# Publish
RUN dotnet publish src/EnterpriseApp.Api/EnterpriseApp.Api.csproj \
    --configuration Release \
    --no-restore \
    --output /app/publish


# =========================
# RUNTIME STAGE
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080

ENTRYPOINT ["dotnet", "EnterpriseApp.Api.dll"]
