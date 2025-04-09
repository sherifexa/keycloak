# terraform.tfvars
keycloak_url = "http://34.42.217.168:8080"
keycloak_admin_username = "admin"
keycloak_admin_password = "admin"  # Change this to your actual admin password

realm_name = "Keycloak"
realm_display_name = "Keycloak"

grafana_client_id = "grafana"
grafana_client_name = "Grafana Dashboard"
grafana_root_url = "http://34.42.217.168"  # Update this to your Grafana URL
grafana_base_url = "/"
grafana_admin_url = "http://34.42.217.168"  # Update this to your Grafana URL

grafana_redirect_uris = [
  "http://34.42.217.168/*",
  "http://34.42.217.168/login/generic_oauth"
]

grafana_web_origins = [
  "http://34.42.217.168"
]
