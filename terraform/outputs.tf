output "staging_namespace" {
  description = "Nombre del namespace de staging creado"
  value       = kubernetes_namespace.staging.metadata[0].name
}

output "production_namespace" {
  description = "Nombre del namespace de produccion creado"
  value       = kubernetes_namespace.production.metadata[0].name
}

output "staging_configmap" {
  description = "Nombre del ConfigMap en staging"
  value       = kubernetes_config_map.app_config_staging.metadata[0].name
}

output "production_configmap" {
  description = "Nombre del ConfigMap en produccion"
  value       = kubernetes_config_map.app_config_production.metadata[0].name
}

output "production_secret" {
  description = "Nombre del Secret en produccion"
  value       = kubernetes_secret.app_secret_production.metadata[0].name
}
