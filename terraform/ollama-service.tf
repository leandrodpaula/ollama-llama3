
# Create the Cloud Run service
resource "google_cloud_run_v2_service" "ollama" {
  name              = "${var.service_name}-models-${var.environment}"
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
          bucket    = google_storage_bucket.ollama.name
          read_only = false
        }
    }

    containers {
      
      image = var.service_ollama_image
      ports {
        container_port = var.service_ollama_port
      }

      resources {
        startup_cpu_boost = "true"
      }

      startup_probe {
        initial_delay_seconds = 3
        timeout_seconds = 3
        period_seconds = 3
        failure_threshold = 3
        tcp_socket {
          port = var.service_ollama_port
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
        mount_path = "/ollama"
      }


    }

   
   

  }
  depends_on = [google_project_service.googleapis]
}

# Allow unauthenticated users to invoke the service
resource "google_cloud_run_service_iam_member" "iam_ollama" {
  service  = google_cloud_run_v2_service.ollama.name
  location = google_cloud_run_v2_service.ollama.location
  role     = "roles/run.invoker"
  member = "serviceAccount:${google_service_account.sa.email}"
}
