# Enterprise .NET + GitHub + Azure + Docker + AKS CI/CD Sample

Flow: Developer -> Feature Branch -> PR -> GitHub Actions PR Quality -> Merge -> Develop/Release CI -> Docker -> ACR -> DEV -> UAT -> SIT -> PRE-PROD -> PROD.

## Prerequisites
.NET 8 SDK, Git, Docker Desktop, Azure CLI, kubectl, Azure subscription, GitHub repository.

## Run locally
```
dotnet restore EnterpriseApp.sln
dotnet build EnterpriseApp.sln
dotnet test EnterpriseApp.sln
dotnet run --project src/EnterpriseApp.Api
```
Endpoints: `/`, `/api/products`, `/health`, `/healthz`.

## Docker
```
docker build -t enterprise-app:local .
docker run --rm -p 8080:8080 enterprise-app:local
```

## Azure example
```
az group create --name rg-enterprise-cicd --location eastus
az acr create --resource-group rg-enterprise-cicd --name <unique-acr-name> --sku Standard
az aks create --resource-group rg-enterprise-cicd --name aks-enterprise-cicd --node-count 2 --enable-managed-identity --attach-acr <unique-acr-name> --generate-ssh-keys
az aks get-credentials --resource-group rg-enterprise-cicd --name aks-enterprise-cicd
kubectl get nodes
```

## GitHub setup
Create environments: `dev`, `uat`, `sit`, `pre-prod`, `production`. Put required reviewers on UAT/SIT/PRE-PROD/PROD. Configure repository variable `ACR_LOGIN_SERVER=<acr>.azurecr.io` and secrets `AZURE_CREDENTIALS`, `AKS_RESOURCE_GROUP`, `AKS_CLUSTER_NAME`.

For production, prefer GitHub OIDC/federated identity over long-lived Azure credentials.

## Branch model
`feature/*` -> PR -> `develop`; develop runs automatic DEV deployment. `release/*` runs release CI and then approval-controlled UAT -> SIT -> PRE-PROD -> PROD.

## Enterprise additions
SonarQube/SonarCloud, Trivy/Defender, secret scanning, SBOM, Key Vault, OIDC, Workload Identity, Helm/Kustomize, Ingress/Application Gateway, Azure Monitor, notifications, rollback, canary/blue-green deployment, image signing, CODEOWNERS and branch protection.
