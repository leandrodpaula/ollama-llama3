#!/bin/bash

# Start Ollama in the background.
/bin/ollama serve &
# Record Process ID.
pid=$!

# Pause for Ollama to start.
sleep 5


models=$START_MODELS

if [ -z "$models" ]; then
  echo "🔴 No models to start."
  exit 1
fi


# Start models.
IFS=';' read -ra models <<< "$models"

for model in "${models[@]}"; do
  echo "🔴 Retrieve $model model..."
  ollama pull $model
  echo "🟢 Done!"
done


# Pause for Ollama to start.
sleep 5

# Read folders in the specified directory.
model_folders=$(ls /ollama/models/manifests/registry.ollama.ai/library)

# Print the folders.
echo "🔴 Available model folders:"
for folder in $model_folders; do
  echo "🟢 Run $folder"
  ollama run $folder &
  echo "🟢 Running $folder"
done

# Wait for Ollama process to finish.
wait $pid