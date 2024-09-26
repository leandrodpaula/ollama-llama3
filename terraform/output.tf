#Oauth output variable
output "oauth_client_id" {
  value = google_integrations_auth_config.oauth.decrypted_credential[0].oauth2_authorization_code[0].client_id
}