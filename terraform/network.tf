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
  depends_on    = [google_compute_network.network]
  private_ip_google_access = true
}
