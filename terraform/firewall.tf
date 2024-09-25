


resource "google_compute_firewall" "allow_ingress_ollama" {
  name    = "${var.project_id}-allow-ingress-ollama-${var.environment}"
  network = google_compute_network.network.name
  direction="INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["${var.service_ollama_port}","22"]
  }

  source_ranges = ["0.0.0.0/0"]
  destination_ranges = ["${google_compute_address.ollama_external_ip.address}","${google_compute_address.ollama_internal_ip.address}"]
}

resource "google_compute_route" "default_internet_route" {
  name       = "${var.project_id}-default-internet-route-${var.environment}"
  network    = google_compute_network.network.name
  next_hop_gateway = "default-internet-gateway"
  priority   = 1000
  dest_range   = "0.0.0.0/0"
}

resource "google_compute_firewall" "allow_egress_ollama" {
  name    = "${var.project_id}-allow-internet-${var.environment}"
  network = google_compute_network.network.name
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443","80","53", "8080","${var.service_ollama_port}", "22"]
  }
  destination_ranges = ["0.0.0.0/0"]
}