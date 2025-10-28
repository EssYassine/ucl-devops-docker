# Étape 1 : image officielle Node.js
FROM node:18-slim

# Étape 2 : définir le répertoire de travail
WORKDIR /app

# Étape 3 : copier les fichiers de configuration
COPY broken-app/package*.json ./

# Étape 4 : installer les dépendances
RUN npm install --production

# Étape 5 : copier le reste du code source
COPY broken-app/ .

# Étape 6 : créer un utilisateur non-root
RUN useradd -m nodeuser && chown -R nodeuser /app

# Étape 7 : exécuter en tant que cet utilisateur
USER nodeuser

# Étape 8 : exposer le port 3000
EXPOSE 3000

# Étape 9 : démarrer l’application
CMD ["node", "server.js"]
