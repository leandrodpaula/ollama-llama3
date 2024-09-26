#!/bin/bash


echo "Starting Ollama startup script..."

# Check if the disk is attached
if [ ! -e /dev/disk/by-id/google-ollama-disk-models ]; then
    echo "Disk not attached. Exiting..."
    exit 1
fi

# Mount the attached disk "ollama-disk" in /ollama
echo "Mounting attached disk in /usr/share/ollama/.ollama/"
sudo mkdir -p /usr/share/ollama/.ollama/models/
sudo chmod -R 777 /usr/share/ollama/.ollama/models/
sudo ls -la /usr/share/ollama/.ollama/models/

# Check if the disk is already formatted
if ! blkid /dev/disk/by-id/google-ollama-disk; then
    echo "Disk is not formatted. Formatting as ext4..."
    sudo mkfs.ext4 -F /dev/disk/by-id/google-ollama-models-disk
fi

# Mount the disk
echo "Mounting the disk..."
sudo mount /dev/disk/by-id/google-ollama-models-disk /usr/share/ollama/.ollama/models


# Ensure the disk is mounted on reboot
sudo bash -c 'echo "/dev/disk/by-id/google-ollama-models-disk /usr/share/ollama/.ollama/models ext4 defaults 0 0" >> /etc/fstab'

# Download and install Ollama


if [ ! -x /usr/local/bin/ollama ]; then
    echo "Downloading and installing Ollama..."
    sudo curl -fsSL https://ollama.com/install.sh | sh
fi


#Create service Ollama Serve
# Create service Ollama Serve
echo "Creating Ollama Serve service..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/ollama.service
[Unit]
Description=Ollama Serve
After=network.target

[Service]
ExecStart=/usr/local/bin/ollama serve
Restart=always
User=root
Group=root
RestartSec=3
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable ollama

sudo systemctl start ollama



# Check if the model llama3.1 exists
if /usr/local/bin/ollama list | grep -q 'llama3.1'; then
    echo "Model llama3.1 found."
else
    echo "Model llama3.1 not found. Starting Ollama..."
    sudo /usr/local/bin/ollama pull llama3.1
    echo "Ollama started."
fi

