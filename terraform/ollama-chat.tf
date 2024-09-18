
# Create the Cloud Run service
resource "google_cloud_run_v2_service" "webui" {
  name              = "${var.service_name}-openwebui-${var.environment}"
  location          = var.region
  ingress           = "INGRESS_TRAFFIC_ALL"
  
  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  }
  timeouts {
    create = "10m"
  }
  template {

    service_account = google_service_account.sa.email
    vpc_access{
      network_interfaces {
        network = google_compute_network.network.name
        subnetwork = google_compute_subnetwork.subnetwork.name
        tags = [var.project_id, var.service_name, "http", "internal"]
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 5
    }

    volumes {
        name = "ollama"
        gcs {
          bucket    = google_storage_bucket.webui.name
          read_only = false
        }
    }


    containers {
      
      image = var.service_webui_image
      ports {
        container_port = var.service_webui_port
      }

      resources {
        startup_cpu_boost = "true"
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
      }

      startup_probe {
        initial_delay_seconds = 20
        timeout_seconds = 30
        period_seconds = 10
        failure_threshold = 5
        tcp_socket {
          port = var.service_webui_port
        }
      }
      liveness_probe {
        initial_delay_seconds = 3
        timeout_seconds = 3
        period_seconds = 3
        http_get {
          path = "/"
        }
      }

      volume_mounts {
        name = "ollama"
        mount_path = "/app/backend/data"
      }

      env{
        name = "OLLAMA_BASE_URL"
        value = google_cloud_run_v2_service.ollama.uri
      }
      env{
        name = "OLLAMA_HOST"
        value = "0.0.0.0"
      }

      env{
        name = "OLLAMA_ORIGINS"
        value = "*"
      }

      env{
        name = "WEBUI_AUTH"
        value = "true"
      }


      env{
        name = "CUSTOM_NAME"
        value = "Verônica"
      }
      

      env{
        name = "ENABLE_OAUTH_SIGNUP"
        value = "true"
      }
      env{
        name = "GOOGLE_CLIENT_ID"
        value = var.oauth_client_id
      }
      env{
        name = "GOOGLE_CLIENT_SECRET"
        value = var.oauth_client_secret
      }
      env{
        name = "OAUTH_PROVIDER_NAME"
        value = "Google"
      }

      env{
        name = "MODEL_FILTER_LIST"
        value = "llama3.1:3b;gemma2:latest"
      }

      env{
        name = "ENABLE_COMMUNITY_SHARING"
        value = "false"
      }

      env{
        name = "OAUTH_MERGE_ACCOUNTS_BY_EMAIL"
        value = "true"
      }

      env{
        name = "DEFAULT_LOCALE"
        value = "pt-br"
      }

    }

   
   

  }
  depends_on = [google_project_service.googleapis]
}

# Allow unauthenticated users to invoke the service
resource "google_cloud_run_service_iam_member" "iam_webui" {
  service  = google_cloud_run_v2_service.webui.name
  location = google_cloud_run_v2_service.webui.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
