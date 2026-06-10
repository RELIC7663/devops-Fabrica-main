# Proyecto DevOps - Fábrica de Software

## Estrategia DevOps para Spring PetClinic

Este repositorio contiene la implementación de una estrategia DevOps aplicada a una aplicación basada en **Spring PetClinic**, adaptada para el proyecto de Fábrica de Software.
La solución integra prácticas de **CI/CD**, contenedores Docker, despliegue en Kubernetes, infraestructura como código, observabilidad, seguridad DevSecOps, métricas DORA y documentación de incidente.

---

## Integrantes

* Johanna Puerchambud
* Hugo Pepinosa
* Luis Flores

---

## Objetivo del proyecto

Diseñar e implementar una estrategia DevOps completa para automatizar el ciclo de vida de una aplicación web, desde la construcción y pruebas hasta el despliegue, monitoreo y análisis de seguridad.

El proyecto busca demostrar:

* Integración continua con GitHub Actions.
* Pruebas automatizadas y cobertura mínima del 80%.
* Construcción de imagen Docker.
* Despliegue en Kubernetes.
* Infraestructura como código con Terraform.
* Observabilidad con Actuator, Prometheus y Grafana.
* Seguridad DevSecOps con Trivy, Gitleaks, CodeQL y CycloneDX.
* Medición de métricas DORA.
* Documentación de un post-mortem.

---

## Tecnologías utilizadas

| Categoría            | Herramienta                                |
| -------------------- | ------------------------------------------ |
| Lenguaje             | Java 21                                    |
| Framework            | Spring Boot                                |
| Construcción         | Maven Wrapper                              |
| Control de versiones | Git y GitHub                               |
| CI/CD                | GitHub Actions                             |
| Contenedores         | Docker                                     |
| Registro de imágenes | GitHub Container Registry                  |
| Orquestación         | Kubernetes con Minikube                    |
| IaC                  | Terraform                                  |
| Observabilidad       | Spring Boot Actuator, Prometheus y Grafana |
| Seguridad            | Trivy, Gitleaks, CodeQL, CycloneDX SBOM    |
| Métricas             | DORA Metrics                               |

---

## Estructura del repositorio

```text
devops-Fabrica-main/
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── cd.yml
│       └── deploy.yml
│
├── app/
│   ├── src/
│   ├── pom.xml
│   ├── mvnw
│   ├── mvnw.cmd
│   └── Dockerfile
│
├── docs/
│
├── k8s/
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── pdb.yaml
│   ├── secret.yaml
│   └── service.yaml
│
├── monitoring/
│
├── security/
│   └── security-report.md
│
├── terraform/
│
├── .gitleaks.toml
└── README.md
```

---

## Requisitos previos

Para ejecutar el proyecto localmente se utilizaron las siguientes herramientas:

| Herramienta | Versión utilizada |
| ----------- | ----------------- |
| Git         | 2.54.0            |
| Java        | Temurin JDK 21    |
| Docker      | 29.4.3            |
| kubectl     | 1.34.1            |
| Minikube    | 1.38.1            |
| Terraform   | 1.15.5            |

---

## Ejecución local de la aplicación

Ingresar a la carpeta de la aplicación:

```powershell
cd app
```

Ejecutar pruebas:

```powershell
.\mvnw.cmd clean test
```

Ejecutar la aplicación localmente:

```powershell
.\mvnw.cmd spring-boot:run
```

Abrir en el navegador:

```text
http://localhost:8080
```

Validar estado de la aplicación:

```powershell
Invoke-WebRequest http://localhost:8080/actuator/health -UseBasicParsing
```

Resultado esperado:

```json
{"status":"UP"}
```

---

## Cobertura de pruebas

El proyecto utiliza **JaCoCo** para generar el reporte de cobertura.

Comando utilizado:

```powershell
.\mvnw.cmd clean test jacoco:report "-Dtest=!PostgresIntegrationTests"
```

Abrir el reporte:

```powershell
start .\target\site\jacoco\index.html
```

Resultado obtenido:

| Métrica                    | Resultado |
| -------------------------- | --------- |
| Cobertura de instrucciones | 90%       |
| Cobertura de ramas         | 83%       |
| Mínimo solicitado          | 80%       |

La cobertura alcanzada cumple con el requisito de la tarea, ya que supera el mínimo solicitado del 80%.

---

## Docker

El proyecto incluye un `Dockerfile` multi-stage para construir una imagen optimizada de la aplicación.

Construir la imagen Docker:

```powershell
cd app
docker build -t petclinic-devops:local .
```

Verificar la imagen creada:

```powershell
docker images
```

Ejecutar el contenedor:

```powershell
docker run --rm -p 8080:8080 --name petclinic-local petclinic-devops:local
```

Validar la aplicación:

```text
http://localhost:8080
```

Validar health check:

```powershell
Invoke-WebRequest http://localhost:8080/actuator/health -UseBasicParsing
```

---

## Pipeline CI/CD

El repositorio cuenta con workflows de GitHub Actions ubicados en:

```text
.github/workflows/
```

Archivos principales:

```text
ci.yml
cd.yml
deploy.yml
```

### CI Pipeline

El pipeline de integración continua ejecuta:

1. Checkout del código.
2. Configuración de Java 21.
3. Cache de dependencias Maven.
4. Compilación del proyecto.
5. Ejecución de pruebas automatizadas.
6. Generación de cobertura JaCoCo.
7. Generación de SBOM con CycloneDX.
8. Construcción de imagen Docker.
9. Escaneo de imagen con Trivy.
10. Publicación de imagen en GitHub Container Registry.

### CD Pipeline

El pipeline de entrega continua contempla dos ambientes:

| Ambiente   | Descripción                                                      |
| ---------- | ---------------------------------------------------------------- |
| Staging    | Despliegue automático después de CI exitoso                      |
| Production | Despliegue con aprobación manual mediante environment protection |

También se incluye despliegue mediante Render usando un `Deploy Hook` configurado como secret en GitHub.

---

## Kubernetes

Los manifiestos de Kubernetes se encuentran en la carpeta:

```text
k8s/
```

Recursos implementados:

| Archivo           | Recurso                         |
| ----------------- | ------------------------------- |
| `deployment.yaml` | Deployment de la aplicación     |
| `service.yaml`    | Service tipo NodePort           |
| `configmap.yaml`  | Configuración externa           |
| `secret.yaml`     | Variables sensibles codificadas |
| `hpa.yaml`        | Horizontal Pod Autoscaler       |
| `pdb.yaml`        | Pod Disruption Budget           |

---

## Despliegue en Minikube

Iniciar Minikube:

```powershell
minikube start --driver=docker --cpus=4 --memory=4096
```

Verificar nodo:

```powershell
kubectl get nodes
```

Cargar imagen local en Minikube:

```powershell
minikube image load petclinic-devops:local
```

Aplicar manifiestos:

```powershell
kubectl apply -f k8s\
```

Verificar recursos:

```powershell
kubectl get pods
kubectl get deployments
kubectl get svc
kubectl get hpa
```

Resultado esperado:

```text
petclinic-xxxxx   1/1   Running
petclinic-yyyyy   1/1   Running
```

Validar rollout:

```powershell
kubectl rollout status deployment/petclinic
```

Obtener URL del servicio:

```powershell
minikube service petclinic-service --url
```

Validar health check:

```powershell
Invoke-WebRequest http://127.0.0.1:PUERTO/actuator/health -UseBasicParsing
```

---

## Probes y recursos en Kubernetes

El Deployment incluye:

* `readinessProbe`
* `livenessProbe`
* `resources.requests`
* `resources.limits`

Esto permite que Kubernetes valide el estado de la aplicación y administre recursos de CPU y memoria.

Ejemplo de validación:

```powershell
kubectl get pods
kubectl logs -l app=petclinic --tail=40
kubectl top pods
kubectl top nodes
```

---

## Observabilidad

La aplicación utiliza **Spring Boot Actuator** y **Micrometer Prometheus** para exponer métricas.

Endpoints principales:

```text
/actuator/health
/actuator/health/liveness
/actuator/health/readiness
/actuator/prometheus
```

Validar métricas Prometheus:

```powershell
Invoke-WebRequest http://127.0.0.1:PUERTO/actuator/prometheus -UseBasicParsing
```

Buscar métricas HTTP:

```powershell
Invoke-WebRequest http://127.0.0.1:PUERTO/actuator/prometheus -UseBasicParsing | Select-String "http_server"
```

---

## Dashboard Grafana

Se implementó un dashboard de observabilidad en Grafana para monitorear indicadores clave del servicio:

| Panel          | Métrica                      |
| -------------- | ---------------------------- |
| Availability   | Disponibilidad del servicio  |
| P99 Latency    | Latencia percentil 99        |
| Request Rate   | Solicitudes por segundo      |
| Error Rate 5xx | Tasa de errores del servidor |
| RAM Used       | Uso de memoria RAM           |

Resultados observados:

| Indicador          | Resultado             |
| ------------------ | --------------------- |
| Availability       | 100%                  |
| SLO disponibilidad | 99.9%                 |
| P99 Latency        | 49.3 ms               |
| SLO latencia       | < 500 ms              |
| RAM Used           | 47 MB aproximadamente |

La observabilidad permite detectar fallos, analizar rendimiento y verificar el cumplimiento de SLO definidos.

---

## Infraestructura como Código - Terraform

La carpeta `terraform/` contiene la configuración de infraestructura como código.

Comandos utilizados:

```powershell
cd terraform
terraform init
terraform fmt -check
terraform validate
```

No se ejecutó `terraform apply`, ya que para la tarea se validó la configuración sin aprovisionar recursos reales en la nube.

Resultado esperado:

```text
Success! The configuration is valid.
```

---

## DevSecOps

La estrategia DevSecOps integra herramientas para detectar vulnerabilidades, secretos y dependencias inseguras.

### Gitleaks

Gitleaks se utiliza para detectar secretos expuestos en el repositorio.

Comando utilizado:

```powershell
docker run --rm -v "${PWD}:/repo" zricethezav/gitleaks:latest detect --source=/repo --no-git --redact --verbose
```

Objetivo:

* Detectar API keys.
* Detectar tokens.
* Detectar contraseñas expuestas.
* Evitar fugas de secretos antes del despliegue.

---

### Trivy

Trivy se utiliza para escanear vulnerabilidades, secretos y malas configuraciones.

Comando utilizado:

```powershell
docker run --rm -v "${PWD}:/repo" aquasec/trivy:latest fs /repo --scanners vuln,secret,misconfig --severity CRITICAL,HIGH
```

Objetivo:

* Analizar dependencias.
* Detectar vulnerabilidades críticas y altas.
* Revisar configuraciones inseguras.
* Fortalecer el flujo DevSecOps.

---

### CycloneDX SBOM

El proyecto genera un SBOM para analizar la composición del software.

Comando utilizado:

```powershell
cd app
.\mvnw.cmd org.cyclonedx:cyclonedx-maven-plugin:makeAggregateBom
```

Archivo generado:

```text
target/bom.xml
```

El SBOM permite conocer las dependencias utilizadas por la aplicación y apoyar el análisis SCA.

---

### CodeQL

CodeQL se considera como herramienta SAST para análisis estático de código fuente.
Su objetivo es detectar vulnerabilidades en el código antes del despliegue.

---

## Métricas DORA

Para evaluar el desempeño DevOps del proyecto se utilizaron las cuatro métricas DORA.

| Métrica DORA          | Resultado del proyecto                                                          | Interpretación                                                                                                 |
| --------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Deployment Frequency  | 1 despliegue por cada cambio validado en la rama principal                      | El proyecto permite despliegues frecuentes mediante GitHub Actions y despliegue automatizado.                  |
| Lead Time for Changes | Aproximadamente entre 5 y 15 minutos                                            | El pipeline ejecuta compilación, pruebas, análisis y construcción de imagen Docker en pocos minutos.           |
| Change Failure Rate   | Bajo, sin fallos funcionales durante la prueba local y despliegue en Kubernetes | La aplicación fue validada con pruebas automatizadas, Docker y Kubernetes antes de considerarse lista.         |
| Mean Time to Recovery | Aproximadamente menor a 10 minutos                                              | En caso de fallo, Kubernetes permite reiniciar pods, rehacer rollout y volver a desplegar la imagen corregida. |

Conclusión:
El proyecto presenta un flujo DevOps funcional, con automatización de pruebas, construcción de imagen Docker, despliegue en Kubernetes, observabilidad y validaciones de seguridad.

---

## Post-mortem del incidente

### Incidente

Error 404 al consultar el endpoint:

```text
/actuator/prometheus
```

### Impacto

La aplicación funcionaba correctamente y el endpoint `/actuator/health` respondía con estado `UP`, pero no se podían obtener métricas en formato Prometheus.

Esto afectaba la observabilidad del sistema, ya que Prometheus no podía recolectar métricas de la aplicación.

### Línea de tiempo

| Hora aproximada | Evento                                                                             |
| --------------- | ---------------------------------------------------------------------------------- |
| 21:55           | Se validó la aplicación en Kubernetes y los pods estaban en estado `Running`.      |
| 22:00           | Se probó `/actuator/health` correctamente con código 200.                          |
| 22:05           | Se intentó acceder a `/actuator/prometheus` y respondió error 404.                 |
| 22:10           | Se revisó la configuración de Actuator y dependencias del proyecto.                |
| 22:15           | Se agregó la dependencia `micrometer-registry-prometheus` en el archivo `pom.xml`. |
| 22:25           | Se reconstruyó la aplicación y la imagen Docker.                                   |
| 22:35           | Se reinició el Deployment en Kubernetes.                                           |
| 22:40           | El endpoint `/actuator/prometheus` respondió correctamente con métricas.           |

### Causa raíz

La aplicación tenía Spring Boot Actuator habilitado, pero no contaba con la dependencia necesaria de Micrometer Prometheus para exponer el endpoint `/actuator/prometheus`.

### Acciones correctivas

1. Agregar la dependencia `micrometer-registry-prometheus` al archivo `pom.xml`.
2. Reconstruir la aplicación con Maven.
3. Reconstruir la imagen Docker.
4. Cargar la nueva imagen en Minikube.
5. Reiniciar el Deployment de Kubernetes.
6. Validar nuevamente el endpoint `/actuator/prometheus`.

### Acciones preventivas

1. Incluir la validación del endpoint `/actuator/prometheus` dentro del pipeline.
2. Documentar los endpoints de observabilidad en el README.
3. Mantener pruebas de health, readiness, liveness y métricas antes de cada entrega.
4. Agregar monitoreo con Prometheus y Grafana como parte del ambiente de despliegue.

### Conclusión del incidente

El incidente fue resuelto sin afectar la disponibilidad general de la aplicación.
La causa fue una dependencia faltante para métricas Prometheus. Como mejora, se fortaleció la observabilidad del sistema y se documentó el proceso de recuperación.

---

## Comandos principales utilizados

### Build y pruebas

```powershell
cd app
.\mvnw.cmd clean test
```

### Cobertura JaCoCo

```powershell
.\mvnw.cmd clean test jacoco:report "-Dtest=!PostgresIntegrationTests"
start .\target\site\jacoco\index.html
```

### Docker

```powershell
docker build -t petclinic-devops:local .
docker run --rm -p 8080:8080 --name petclinic-local petclinic-devops:local
```

### Kubernetes

```powershell
minikube start --driver=docker --cpus=4 --memory=4096
minikube image load petclinic-devops:local
kubectl apply -f k8s\
kubectl get pods
kubectl get svc
kubectl get hpa
```

### Observabilidad

```powershell
minikube service petclinic-service --url
Invoke-WebRequest http://127.0.0.1:PUERTO/actuator/health -UseBasicParsing
Invoke-WebRequest http://127.0.0.1:PUERTO/actuator/prometheus -UseBasicParsing
```

### Terraform

```powershell
cd terraform
terraform init
terraform fmt -check
terraform validate
```

### DevSecOps

```powershell
docker run --rm -v "${PWD}:/repo" zricethezav/gitleaks:latest detect --source=/repo --no-git --redact --verbose
docker run --rm -v "${PWD}:/repo" aquasec/trivy:latest fs /repo --scanners vuln,secret,misconfig --severity CRITICAL,HIGH
```

---

## Resultados obtenidos

| Requisito       | Resultado                                                           |
| --------------- | ------------------------------------------------------------------- |
| Build y pruebas | Correcto                                                            |
| Cobertura ≥80%  | 90%                                                                 |
| Docker          | Imagen construida y ejecutada                                       |
| Kubernetes      | Pods en estado `Running`                                            |
| HPA             | Configurado con mínimo 2 y máximo 10 réplicas                       |
| Health check    | Estado `UP`                                                         |
| Prometheus      | Endpoint `/actuator/prometheus` habilitado                          |
| Grafana         | Dashboard con disponibilidad, latencia, request rate, errores y RAM |
| Terraform       | Configuración validada                                              |
| DevSecOps       | Escaneo con Trivy, Gitleaks, SBOM y CodeQL                          |
| DORA            | Métricas documentadas                                               |
| Post-mortem     | Incidente documentado                                               |

---

## Conclusión

El proyecto implementa una estrategia DevOps completa para una aplicación Spring Boot.
Se automatizó el proceso de construcción, pruebas, cobertura, seguridad, contenedorización y despliegue. Además, se implementó observabilidad mediante Prometheus y Grafana, validación de infraestructura con Terraform, análisis DevSecOps y documentación de métricas DORA.

La solución cumple con los requisitos principales de la tarea y demuestra un flujo DevOps funcional, medible y seguro.
