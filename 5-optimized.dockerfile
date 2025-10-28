# ---------------------------
# Étape 1 : Build
# ---------------------------
FROM golang:1.21-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers Go
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Compiler l’application statiquement
RUN CGO_ENABLED=0 GOOS=linux go build -o app

# ---------------------------
# Étape 2 : Runtime minimal
# ---------------------------
FROM scratch

# Créer un utilisateur non-root
# scratch n’a pas adduser, donc on crée un UID directement
USER 1001

# Copier le binaire depuis le builder
COPY --from=builder /app/app /app/app

# Exposer le port (ajuster selon l’app)
EXPOSE 8080

# Démarrer l’application
ENTRYPOINT ["/app/app"]
