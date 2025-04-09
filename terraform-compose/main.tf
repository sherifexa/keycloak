# main.tf
terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "~> 4.3.1"
    }
  }
}

provider "keycloak" {
  client_id     = "admin-cli"
  username      = var.keycloak_admin_username
  password      = var.keycloak_admin_password
  url           = var.keycloak_url
  initial_login = true
}

# Create a realm for our applications
resource "keycloak_realm" "app_realm" {
  realm   = var.realm_name
  enabled = true

  display_name      = var.realm_display_name
  display_name_html = "<strong>${var.realm_display_name}</strong>"

  access_code_lifespan = "1h"
  ssl_required         = "none"
  
  # Registration settings
  registration_allowed           = true
  registration_email_as_username = false
  reset_password_allowed         = true
  remember_me                    = true
  verify_email                   = false
  login_with_email_allowed       = true
  duplicate_emails_allowed       = false
}

# Create Grafana client
resource "keycloak_openid_client" "grafana_client" {
  realm_id                     = keycloak_realm.app_realm.id
  client_id                    = var.grafana_client_id
  name                         = var.grafana_client_name
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  
  root_url                     = var.grafana_root_url
  base_url                     = var.grafana_base_url
  admin_url                    = var.grafana_admin_url
  
  valid_redirect_uris = var.grafana_redirect_uris
  web_origins         = var.grafana_web_origins
}

# Get the client secret after creation
resource "keycloak_openid_client_default_scopes" "grafana_default_scopes" {
  realm_id  = keycloak_realm.app_realm.id
  client_id = keycloak_openid_client.grafana_client.id
  
  default_scopes = [
    "profile",
    "email",
    "roles",
    "web-origins"
  ]
}

# Create roles for Grafana
resource "keycloak_role" "grafana_admin_role" {
  realm_id    = keycloak_realm.app_realm.id
  name        = "grafana-admin"
  description = "Grafana Admin Role"
}

resource "keycloak_role" "grafana_editor_role" {
  realm_id    = keycloak_realm.app_realm.id
  name        = "grafana-editor"
  description = "Grafana Editor Role"
}

resource "keycloak_role" "grafana_viewer_role" {
  realm_id    = keycloak_realm.app_realm.id
  name        = "grafana-viewer"
  description = "Grafana Viewer Role"
}

# Protocol mappers for passing role information to Grafana
resource "keycloak_openid_user_attribute_protocol_mapper" "grafana_roles_mapper" {
  realm_id            = keycloak_realm.app_realm.id
  client_id           = keycloak_openid_client.grafana_client.id
  name                = "grafana-roles"
  user_attribute      = "grafana_roles"
  claim_name          = "grafana_roles"
  claim_value_type    = "String"
  multivalued         = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

# Output client secret for Grafana configuration
output "grafana_client_secret" {
  value     = keycloak_openid_client.grafana_client.client_secret
  sensitive = true
  description = "The client secret for Grafana OAuth configuration"
}

output "grafana_client_id" {
  value       = keycloak_openid_client.grafana_client.client_id
  description = "The client ID for Grafana OAuth configuration"
}

output "keycloak_realm_name" {
  value       = keycloak_realm.app_realm.realm
  description = "The realm name for Grafana OAuth configuration"
}

output "keycloak_url" {
  value       = var.keycloak_url
  description = "The Keycloak server URL"
}
