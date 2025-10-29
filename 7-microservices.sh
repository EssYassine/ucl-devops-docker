#!/bin/bash
set -e

echo "🚀 Setting up Microservices environment..."

# Clean old files if they exist
rm -f docker-compose.yml init.sql

# Step 1: Create init.sql
cat > init.sql <<'EOF'
CREATE TABLE IF NOT EXISTS processed_tasks (
    id SERIAL PRIMARY KEY,
    task_data TEXT,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

# Step 2: Create docker-compose.yml
cat > docker-compose.yml <<'EOF'
services:
  api:
    build: ./microservices-app/api
    ports:
      - "4000:4000"
    environment:
      - DB_HOST=db
      - DB_PORT=5432
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - DB_NAME=microservices
      - REDIS_HOST=redis
    depends_on:
      - db
      - redis
    networks:
      - micro-net

  worker:
    build: ./microservices-app/worker
    environment:
      - DB_HOST=db
      - DB_PORT=5432
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - DB_NAME=microservices
      - REDIS_HOST=redis
    depends_on:
      - db
      - redis
    networks:
      - micro-net

  redis:
    image: redis:alpine
    networks:
      - micro-net

  db:
    image: postgres:alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=microservices
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - micro-net

volumes:
  pgdata:

networks:
  micro-net:
EOF

echo "🛠️  Building and starting containers..."
docker compose up -d --build

echo "✅ Environment started! Access API on http://localhost:4000"

