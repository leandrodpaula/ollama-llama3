sudo apt-get update -y
sudo apt-get install -y curl

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "Unsupported architecture: $ARCH" ;;
esac

# Mount the attached disk "ollama-disk" in /root/.ollama
echo "Mounting attached disk in /root/.ollama..."
sudo mkdir -p /root/.ollama
sudo chmod -R 777 /root/.ollama

# Check if the disk is already formatted
if ! blkid /dev/disk/by-id/google-ollama-disk; then
    echo "Disk is not formatted. Formatting as ext4..."
    sudo mkfs.ext4 -F /dev/disk/by-id/google-ollama-disk

fi

# Mount the disk
sudo mount /dev/disk/by-id/google-ollama-disk /root/.ollama

# Ensure the disk is mounted on reboot
sudo bash -c 'echo "/dev/disk/by-id/google-ollama-disk /root/.ollama ext4 defaults 0 0" >> /etc/fstab'


# Download and install Ollama
echo "Downloading and installing Ollama..."

curl -fsSL https://ollama.com/install.sh | sh

if [ ! -x /usr/local/bin/ollama ]; then
    error "Ollama executable not found in /usr/local/bin"
fi

if [  -x /usr/local/bin/ollama ]; then
    echo "Ollama executable is found in /usr/local/bin"

# Create a systemd service for Ollama

echo "Creating systemd service for Ollama..."

sudo bash -c 'cat <<EOF > /etc/systemd/system/ollama.service
[Unit]
Description=Ollama Service
After=network.target

[Service]
ExecStart=/usr/local/bin/ollama serve
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable ollama.service
sudo systemctl start ollama.service

echo "Ollama service started."

if ! sudo ollama list | grep -q "llama3.1"; then
    echo "Pulling llama3.1"
    sudo ollama pull llama3.1
    sudo ollama run llama3.1
fi

if ! sudo ollama list | grep -q "llama2"; then
    echo "Pulling llama2"
    sudo ollama pull llama2
    sudo ollama run llama2
fi



