#!/bin/bash

set -e

echo "🦙 Installing Ollama"
echo "===================="

# Check if Ollama already installed
if command -v ollama &> /dev/null; then
    echo "✓ Ollama already installed"
    ollama --version
    exit 0
fi

# Install Ollama
echo "Downloading Ollama..."
curl -fsSL https://ollama.ai/install.sh | sh

echo "✓ Ollama installed"

# Create ollama service directory
mkdir -p ~/.ollama

# Download recommended models
echo ""
echo "Downloading recommended models..."
echo "(This may take a few minutes)"

models=("mistral" "neural-chat" "llama2-uncensored")

for model in "${models[@]}"; do
    echo "Pulling $model..."
    ollama pull "$model" &
done

wait

echo ""
echo "✓ Ollama and models ready"
echo ""
echo "Usage:"
echo "  ollama pull <model>    # Download a model"
echo "  ollama run <model>     # Run a model"
echo "  ollama list            # List models"
echo ""
echo "Available models: https://ollama.ai/library"
