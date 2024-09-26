resource "google_integrations_client" "client" {
  location = var.region
}

resource "google_integrations_auth_config" "oauth" {
    location = var.region
    display_name = "Verônica"
    description = "Login OAuth Google Verônica"
    decrypted_credential {
        credential_type = "oauth2_authorization_code"
        oauth2_authorization_code{
            auth_endpoint = "${google_cloud_run_v2_service.webui.uri}/auth/google/callback"
        }
    }
    depends_on = [google_integrations_client.client]
}