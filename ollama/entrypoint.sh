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


echo "🔴 Retrieve LLAMA2 model..."
ollama pull llama2
echo "🟢 Done!"

# Pause for Ollama to start.
sleep 5

echo "🔴 Retrieve LLAMA3 model..."
ollama pull llama3
echo "🟢 Done!"

# Wait for Ollama process to finish.
wait $pid