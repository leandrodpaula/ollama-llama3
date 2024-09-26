#!/bin/bash

# Start Ollama in the background.
/bin/ollama serve &
# Record Process ID.
pid=$!

# Pause for Ollama to start.
sleep 5


models=$START_MODELS

# Read folders in the specified directory.
model_folders=$(ls /root/.ollama/models/manifests/registry.ollama.ai/library)

# Start models.
IFS=';' read -ra models <<< "$models"

for model in "${models[@]}"; do
  if [[ " ${model_folders[@]} " =~ " ${model} " ]]; then
    echo "🔴 Model $model already exists!" 
    continue
  fi

  echo "🔴 Retrieve $model model..."
  ollama pull $model
  echo "🟢 Done!"
done


# Wait for the Ollama process to finish.
wait $pid