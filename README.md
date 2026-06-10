
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


## Observabilidad y SLOs

Para cumplir con los objetivos de nivel de servicio (SLO), hemos definido los siguientes indicadores (SLI):

*   **Disponibilidad (Availability)**: 
    *   **SLI**: Porcentaje de respuestas HTTP exitosas (no 5xx) frente al total de peticiones en los últimos 5 minutos.
    *   **SLO**: **99.9%** de disponibilidad constante.
*   **Latencia (Latency)**: 
    *   **SLI**: Tiempo de respuesta para el percentil 99 (P99).
    *   **SLO**: Menos de **500ms** para el 99% de las peticiones.

Se ha configurado Prometheus y Grafana para visualizar estas métricas en un **SLO Dashboard**. Adicionalmente, las alertas de Prometheus se disparan cuando:
1.  La tasa de errores supera el 0.1% durante 5 minutos (riesgo para el SLO de Disponibilidad).
2.  La latencia P99 supera los 500ms durante 5 minutos (riesgo para el SLO de Latencia).

Para los logs, la aplicación expone métricas y registros con `trace_id` para correlacionar eventos a lo largo de los servicios, y se visualizan a través del panel de logs en Grafana.
