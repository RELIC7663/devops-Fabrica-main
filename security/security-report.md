# Reporte de Seguridad DevSecOps

## Herramientas implementadas

### 1. Trivy - Container Scanning
- **Funcion:** Escanea la imagen Docker por vulnerabilidades CVE en paquetes OS y librerias
- **Integracion:** Ejecutado en el pipeline CI (ci.yml) despues del Docker build
- **Politica:** Reporta vulnerabilidades CRITICAL y HIGH
- **Evidencia:** Ver logs del job "Docker Build, Scan & Push" en GitHub Actions

### 2. Gitleaks - Secret Detection
- **Funcion:** Detecta credenciales hardcodeadas antes de que lleguen al repositorio
- **Integracion:** Pre-commit hook local + verificacion en CI
- **Configuracion:** Archivo .gitleaks.toml en la raiz del repositorio

### 3. OWASP ZAP - DAST (Dynamic Application Security Testing)
- **Funcion:** Escaneo dinamico contra la aplicacion desplegada en staging
- **Tipo:** Baseline scan (pasivo) contra endpoints principales
- **Alcance:** OWASP Top 10 vulnerabilities

### 4. Kubernetes Secrets
- **Funcion:** Gestion de secretos sensibles (passwords, API keys)
- **Implementacion:** K8s Secrets con datos codificados en base64
- **Acceso:** Solo pods autorizados via RBAC

## SLI/SLO Definidos

| Indicador (SLI) | Objetivo (SLO) | Ventana |
|-----------------|----------------|---------|
| Disponibilidad (requests exitosos / total) | 99.9% | 30 dias |
| Latencia P99 | < 500ms | 30 dias |
| Error Rate (5xx) | < 1% | 30 dias |

## Error Budget
- SLO: 99.9% = 0.1% error budget
- En 30 dias: 43.2 minutos de downtime permitido
