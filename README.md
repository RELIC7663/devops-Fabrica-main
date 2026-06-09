# Proyecto DevOps - PetClinic

![CI Pipeline](https://github.com/alexlunamayo2002-netizen/proyecto-devops/actions/workflows/ci.yml/badge.svg)
![CD Pipeline](https://github.com/alexlunamayo2002-netizen/proyecto-devops/actions/workflows/cd.yml/badge.svg)

## Arquitectura del Proyecto

```
+-------------------+     +-------------------+     +-------------------+
|    DEVELOPER      |     |    CI PIPELINE    |     |   CD PIPELINE     |
|                   |     |  GitHub Actions   |     |  GitHub Actions   |
| git push -> PR    +---->+ Build + Test      +---->+ Deploy Staging    |
|                   |     | SAST (Trivy)      |     | Deploy Production |
|                   |     | Docker Build+Push |     | (manual approval) |
+-------------------+     +-------------------+     +-------------------+
                                                            |
                                                            v
+-------------------+     +-------------------+     +-------------------+
|  OBSERVABILITY    |     |   KUBERNETES      |     |  INFRASTRUCTURE   |
|                   |     |   (minikube)      |     |  AS CODE          |
| Prometheus        |<----+ Deployment (HA)   |     | Terraform         |
| Grafana Dashboard |     | HPA (2-10 pods)   |<----+ Namespaces        |
| SLO Monitoring    |     | ConfigMap+Secret  |     | ConfigMaps        |
|                   |     | PDB               |     | Secrets           |
+-------------------+     +-------------------+     +-------------------+
```

## Stack Tecnologico

| Componente | Tecnologia |
|-----------|-----------|
| Aplicacion | Spring Boot 3 + Java 21 |
| CI/CD | GitHub Actions |
| Contenedores | Docker (multi-stage) |
| Registry | GitHub Container Registry (ghcr.io) |
| Orquestacion | Kubernetes (minikube) |
| IaC | Terraform (Kubernetes provider) |
| Monitoreo | Prometheus + Grafana |
| Seguridad | Trivy + gitleaks |

## Estructura del Repositorio

```
proyecto-devops/
├── app/                    # Codigo Spring Boot + Dockerfile
├── .github/workflows/      # CI (ci.yml) + CD (cd.yml)
├── k8s/                    # Manifiestos Kubernetes
├── terraform/              # Infrastructure as Code
├── monitoring/             # Prometheus + Grafana dashboards
├── security/               # Reportes de seguridad
└── docs/                   # DORA metrics + Post-mortem
```

## Metricas DORA

| Metrica | Valor | Clasificacion |
|---------|-------|--------------|
| Deployment Frequency | 3/semana | Low |
| Lead Time | 30 min | Elite |
| Change Failure Rate | 33% | High |
| MTTR | 5 min | Elite |

## Como ejecutar

```bash
# Clonar
git clone https://github.com/alexlunamayo2002-netizen/proyecto-devops.git

# Build local
cd app && ./mvnw package -DskipTests

# Docker
docker build -t petclinic:latest ./app

# Kubernetes
minikube start --cpus=2 --memory=2500
kubectl apply -f k8s/

# Terraform
cd terraform && terraform init && terraform plan
```

## Autores
- Equipo proyecto-devops - Fabrica de Software 8vo Nivel

<!-- demo live -->

<!-- demo live test -->

<!-- Prueba demo -->

<!-- Crear Demo en vivo -->
