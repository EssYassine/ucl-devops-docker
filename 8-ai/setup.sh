#!/bin/bash
set -e

echo "🚀 Starting Local AI Chat Setup..."

# Start Docker services
docker compose up -d

# Pull Ollama model
echo "🧠 Pulling qwen2.5:3b model..."
docker exec -it ollama ollama pull qwen2.5:3b

echo "✅ Setup complete!"
echo "🌐 Access LibreChat at: http://localhost:3000"

