resource "google_compute_instance" "ollama" {
  count        = var.create_instance_group ? 0 : 1
  name         = "${var.service_name}-models-${var.environment}"
  machine_type = "e2-medium"
  can_ip_forward = true
  tags = [var.project_id, var.service_name, "http", "internal","http-server", "https-server"]
  zone = var.zone
    boot_disk {
      initialize_params {
        image =  "ubuntu-os-cloud/ubuntu-2004-lts"
      }
    }

    attached_disk {
        device_name = "ollama-disk"
        source = google_compute_disk.ollama_disk.id 
    }

  service_account {
    email  = google_service_account.sa.email
    scopes = ["cloud-platform","compute-rw"]
  }
  network_interface {
    network    = google_compute_network.network.name
    subnetwork = google_compute_subnetwork.subnetwork.name
    network_ip = google_compute_address.ollama_internal_ip.address
    stack_type = "IPV4_ONLY"
    nic_type = "GVNIC"
  }

  metadata_startup_script = file("../ollama/startup-script.sh")

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }
}