


resource "google_compute_firewall" "allow_to_ollama" {
  name    = "${var.project_id}-allow-to-ollama-${var.environment}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.service_ollama_port}","22"]
  }

  source_ranges = ["0.0.0.0/0"]
  destination_ranges = ["${google_compute_address.ollama_internal_ip.address}"]
}



resource "google_compute_firewall" "allow_from_ollama" {
  name    = "${var.project_id}-allow-from-ollama-${var.environment}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.service_ollama_port}","22"]
  }

  source_ranges =  ["${google_compute_address.ollama_internal_ip.address}"] 
  destination_ranges = ["0.0.0.0/0"]
}