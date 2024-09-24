
variable "project_id" {}
variable "region" { default = "us-east1" }
variable "subnet_cidr" { default = "10.76.0.0/24" }
variable "environment" {}

variable "service_name" { default = "ollama" }

variable "service_ollama_port" { default = "11434" }
variable "service_webui_port" { default = "8080" }
    
variable "service_ollama_image" {default = "gcr.io/ollama-lab/ollama:latest"}
variable "service_webui_image" {default = "gcr.io/ollama-lab/open-webui:latest"}

variable "oauth_client_id" { default = "xxxxx"}
variable "oauth_client_secret" { default = "xxxxx"}

variable "zone" { default = "us-east1-b" }
variable "create_instance_group" { default = false }

variable "create_webui" { default = true }