resource "google_compute_network" "network" {
  project                           = var.project_id
  name                              = "${var.project_id}-vpc-${var.environment}"
  auto_create_subnetworks           = false
  delete_default_routes_on_create   = true
  mtu                               = 1460
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "${var.project_id}-vpc-subnet-${var.environment}"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.network.self_link
  private_ip_google_access = true
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
}


resource "google_compute_address" "ollama_internal_ip" {
  name         = "${var.project_id}-instance-internal-ip-${var.environment}"
  subnetwork   = google_compute_subnetwork.subnetwork.id
  address_type = "INTERNAL"
  region       = var.region
}

