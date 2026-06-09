terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  # Backend local para desarrollo
  # En produccion se usaria S3 + DynamoDB:
  # backend "s3" {
  #   bucket         = "proyecto-devops-tfstate"
  #   key            = "production/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# ── RECURSO 1: Namespace staging ──────────────────────
resource "kubernetes_namespace" "staging" {
  metadata {
    name = var.staging_namespace
    labels = {
      environment = "staging"
      managed-by  = "terraform"
    }
  }
}

# ── RECURSO 2: Namespace production ───────────────────
resource "kubernetes_namespace" "production" {
  metadata {
    name = var.production_namespace
    labels = {
      environment = "production"
      managed-by  = "terraform"
    }
  }
}

# ── RECURSO 3: ConfigMap en staging ───────────────────
resource "kubernetes_config_map" "app_config_staging" {
  metadata {
    name      = "petclinic-config"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }

  data = {
    SPRING_PROFILES_ACTIVE                      = "staging"
    SERVER_PORT                                  = "8080"
    MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE    = "health,info,prometheus,metrics"
    MANAGEMENT_ENDPOINT_HEALTH_PROBES_ENABLED    = "true"
  }
}

# ── RECURSO 4: ConfigMap en production ────────────────
resource "kubernetes_config_map" "app_config_production" {
  metadata {
    name      = "petclinic-config"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  data = {
    SPRING_PROFILES_ACTIVE                      = "production"
    SERVER_PORT                                  = "8080"
    MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE    = "health,info,prometheus"
    MANAGEMENT_ENDPOINT_HEALTH_PROBES_ENABLED    = "true"
  }
}

# ── RECURSO 5: Secret en production ───────────────────
resource "kubernetes_secret" "app_secret_production" {
  metadata {
    name      = "petclinic-secret"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  data = {
    DB_PASSWORD = var.db_password
    API_KEY     = var.api_key
  }

  type = "Opaque"
}
