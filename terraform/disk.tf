resource "google_compute_disk" "ollama_disk" {
    name  = "${var.service_name}-disk-${var.environment}"
    type  = "pd-ssd"
    zone  = var.zone
    size  = 250 # Tamanho do disco em GB

    labels = {
        environment  = var.environment
        service_name = var.service_name
        project      = var.project_id
    }
}