resource "google_storage_bucket" "webui" {
  name       = "${var.service_name}-chat-${var.environment}"
  location   = var.region
  project   = var.project_id
  storage_class = "NEARLINE"
  public_access_prevention = "enforced"
  depends_on = [google_project_service.googleapis]
  force_destroy = false
  uniform_bucket_level_access = false
  labels = {
    environment  = var.environment
    service_name = "${var.service_name}"
    project      = var.project_id
  }
  
}

resource "google_storage_bucket_iam_member" "bucket_webui_access" {
  bucket = google_storage_bucket.webui.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.sa.email}"
}
