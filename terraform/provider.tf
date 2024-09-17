terraform {
  required_version = ">= 0.12"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 6.0.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = ">= 1.18.1"
    }
  }  
  backend "gcs" {}
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "terraform_remote_state" "remote" {
  backend = "gcs"
  config = {
    bucket      = "${var.project_id}-tfstate"
    prefix      = "${var.service_name}/${var.environment}"
  }
}

resource "google_project_service" "googleapis" {
  service = "run.googleapis.com"
  project = var.project_id
}