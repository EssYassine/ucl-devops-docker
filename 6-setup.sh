#!/bin/bash
# Arrêt en cas d'erreur
set -e

# Créer le dossier pour Docker Compose
mkdir -p postgres-db
cd postgres-db

# Créer le fichier docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3.8'

services:
  db:
    image: postgres:15
    container_name: test-postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: testdb
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    ports:
      - "5432:5432"

volumes:
  pgdata:
EOF

# Créer le script d'initialisation SQL
cat > init.sql <<EOF
-- Création de la table users
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Création de la table products
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL
);
EOF

# Lancer PostgreSQL avec Docker Compose
docker compose up -d

echo "PostgreSQL setup terminé. Base testdb initialisée et persistante sur le port 5432."
