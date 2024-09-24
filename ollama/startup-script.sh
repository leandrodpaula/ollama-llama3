#!/bin/sh
# This script installs Ollama on a Linux instance.

set -eu

status() { echo ">>> $*" >&2; }
error() { echo "ERROR $*"; exit 1; }

# Update and install necessary packages
status "Updating package list and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) error "Unsupported architecture: $ARCH" ;;
esac



# Mount the attached disk "ollama-disk" in /root/.ollama
status "Mounting attached disk in /root/.ollama..."
sudo mkdir -p /root/.ollama
sudo mount /dev/disk/by-id/google-ollama-disk /root/.ollama



# Download and install Ollama
status "Downloading and installing Ollama..."

curl -fsSL https://ollama.com/install.sh | sh

if [ ! -x /usr/local/bin/ollama ]; then
    error "Ollama executable not found in /usr/local/bin"
fi

if [  -x /usr/local/bin/ollama ]; then
    error "Ollama executable is found in /usr/local/bin"

# Create a systemd service for Ollama

status "Creating systemd service for Ollama..."

sudo tee /etc/systemd/system/ollama.service > /dev/null <<EOF
[Unit]
Description=Ollama Service
After=network.target

[Service]
ExecStart=/usr/local/bin/ollama serve
ExecStart=/usr/local/bin/ollama run llama2 --port \${OLLAMA_PORT}
ExecStart=/usr/local/bin/ollama run llama3.1 --port \${OLLAMA_PORT}
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reload
sudo systemctl enable ollama.service
sudo systemctl start ollama.service

status "Ollama service created and started."

fi