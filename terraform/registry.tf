resource "google_artifact_registry_repository" "docker_artifacts" {
  location      = var.region
  repository_id = "build-artifacts"
  description   = "Build Images of ${var.project_id}"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }

  cleanup_policies{
    id = "build-artifacts-policies"
    action = "KEEP"
    most_recent_versions {
        keep_count = 3
    }
  }
}
