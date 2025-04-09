# variables.tf
variable "keycloak_url" {
  description = "The URL of the Keycloak server"
  type        = string
  default     = "http://34.42.217.168:8080"
}

variable "keycloak_admin_username" {
  description = "The username of the Keycloak admin"
  type        = string
  default     = "admin"
}

variable "keycloak_admin_password" {
  description = "The password of the Keycloak admin"
  type        = string
  sensitive   = true
  # Don't set a default for sensitive values
}

variable "realm_name" {
  description = "The name of the Keycloak realm"
  type        = string
  default     = "applications"
}

variable "realm_display_name" {
  description = "The display name of the Keycloak realm"
  type        = string
  default     = "Applications Realm"
}

variable "grafana_client_id" {
  description = "The client ID for Grafana"
  type        = string
  default     = "grafana"
}

variable "grafana_client_name" {
  description = "The client name for Grafana"
  type        = string
  default     = "Grafana Dashboard"
}

variable "grafana_root_url" {
  description = "The root URL for Grafana"
  type        = string
  default     = "http://localhost:3000"
}

variable "grafana_base_url" {
  description = "The base URL for Grafana"
  type        = string
  default     = "/"
}

variable "grafana_admin_url" {
  description = "The admin URL for Grafana"
  type        = string
  default     = "http://localhost:3000"
}

variable "grafana_redirect_uris" {
  description = "The redirect URIs for Grafana"
  type        = list(string)
  default     = ["http://localhost:3000/*", "http://localhost:3000/login/generic_oauth"]
}

variable "grafana_web_origins" {
  description = "The web origins for Grafana"
  type        = list(string)
  default     = ["http://localhost:3000"]
}
