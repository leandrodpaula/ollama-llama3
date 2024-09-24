resource "google_compute_instance_template" "template" {
    count        = var.create_instance_group ? 1 : 0
    name         = "${var.project_id}-instance-template-${var.environment}"
    machine_type = "e2-medium"
    region       = var.region
    
    disk {
        source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
        auto_delete  = true
        boot         = true
    }

     disk {
        device_name = "ollama-disk"
        source = google_compute_disk.ollama_disk.name 
        auto_delete  = false
        boot         = false
    }

    network_interface {
        network    = google_compute_network.network.self_link
        subnetwork = google_compute_subnetwork.subnetwork.self_link
    }

    metadata = {
        startup-script = file("../ollama/startup-script.sh")
    }

    service_account {
        email  = google_service_account.sa.email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }
}

resource "google_compute_instance_group_manager" "instance_group" {
    count        = var.create_instance_group ? 1 : 0
    name               = "${var.project_id}-instance-group-${var.environment}"
    base_instance_name = "${var.project_id}-instance-${var.environment}"
    version {
        instance_template = google_compute_instance_template.template[0].self_link
    }
    target_size = 1
    zone = var.zone
}

resource "google_compute_autoscaler" "autoscaler" {
    count        = var.create_instance_group ? 1 : 0
    name    = "${var.project_id}-autoscaler-${var.environment}"
    target  = google_compute_instance_group_manager.instance_group[0].self_link
    zone    = var.zone
    autoscaling_policy {
        max_replicas    = 1
        min_replicas    = 1
        cooldown_period = 60

        cpu_utilization {
            target = 0.6
        }
    }
}


