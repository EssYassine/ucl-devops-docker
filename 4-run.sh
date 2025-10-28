#!/bin/bash
# Build et exécution du conteneur Node.js

# Arrêt en cas d’erreur
set -e

# Construire l’image
docker build -t dev-app -f 4-dev-app.dockerfile .

# Lancer le conteneur sur le port 3000
docker run --rm -p 3000:3000 dev-app
