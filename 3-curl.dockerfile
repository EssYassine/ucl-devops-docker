# Utiliser une image légère (Debian slim)
FROM debian:bullseye-slim

# Installer curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non-root
RUN useradd -m curluser

# Changer pour l'utilisateur non-root
USER curluser

# Définir le point d'entrée pour passer l'URL en argument
ENTRYPOINT ["curl"]
