project_id = "ollama-lab"
region = "us-east1"
subnet_cidr = "10.76.0.0/24"
environment = "hml"
service_name = "ollama"
service_ollama_port = "11434"
service_webui_port = "8080"
service_ollama_image = "gcr.io/ollama-lab/ollama:latest"
service_webui_image = "gcr.io/ollama-lab/open-webui:latest"