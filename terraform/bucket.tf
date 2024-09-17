


resource "google_storage_bucket" "ollama" {
  name       = "${var.service_name}-${var.environment}"
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


resource "google_storage_bucket_object" "webui_folder" {
  name   = "chat"
  content = " "            # content is ignored but should be non-empty
  bucket = google_storage_bucket.ollama.name
}


resource "google_storage_bucket_object" "models_folder" {
  name   = "models"
  content = " "            # content is ignored but should be non-empty
  bucket = google_storage_bucket.ollama.name
}

resource "google_storage_bucket_iam_member" "bucket_access" {
  bucket = google_storage_bucket.ollama.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.sa.email}"
}

