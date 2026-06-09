variable "staging_namespace" {
  description = "Nombre del namespace de staging en Kubernetes"
  type        = string
  default     = "staging"
}

variable "production_namespace" {
  description = "Nombre del namespace de produccion en Kubernetes"
  type        = string
  default     = "production"
}

variable "db_password" {
  description = "Password de la base de datos"
  type        = string
  sensitive   = true
  default     = "petclinic123"
}

variable "api_key" {
  description = "API key de la aplicacion"
  type        = string
  sensitive   = true
  default     = "secure-api-key-123"
}
