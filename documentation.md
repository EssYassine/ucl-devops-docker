# TP DevOps / Docker – Documentation des exercices

> **Environnement :**
> - Hôte : Ubuntu 22.04.3 (machine virtuelle)
> - Auteur : *Yassine Essaouri*
> - Cours : *M1 Cybersécurité – DevOps / Docker*
> - Dépôt de base : [Anthony-Jhoiro/2025-devops-docker](https://github.com/Anthony-Jhoiro/2025-devops-docker)

&nbsp;


## ⚙️ Configuration initiale
Avant de commencer :

```bash
sudo apt update
sudo apt install docker.io git -y
sudo systemctl enable --now docker
git clone https://github.com/EssYassine/ucl-devops-docker.git
cd ucl-devops-docker
```
Vérification :
```bash
docker --version
git --version
```

&nbsp;

## 🐋 Exercice 1 – Hello Whale
### Objectif :

Faire tourner un conteneur Docker qui affiche un message personnalisé puis se supprime automatiquement après son exécution.

### Contraintes :

- **Image :** ```anthonyjhoiro/whalesay```

- **Message :** "Hello M1 Cyber 2025"


- **Script :** ```1-hello-whale.sh``` à la racine du dépôt.

- Le conteneur doit être supprimé après exécution.

### Commande Docker de base :

Fichier : ```1-hello-whale.sh```
```bash
#!/bin/bash
docker run --rm anthonyjhoiro/whalesay cowsay "Hello M1 Cyber 2025"
```

Rendre exécutable :
```bash
chmod +x 1-hello-whale.sh
```

Exécuter :
```bash
./1-hello-whale.sh
```

Résultat obtenu : 
```python
 _____________________
< Hello M1 Cyber 2025 >
 ---------------------
   \               ##         .
    \        ## ## ##        ==
          ## ## ## ##       ===
       /""""""""""""""""\___/ ===
  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
       \______ o          __/
         \    \        __/
          \____\______/

```
Le conteneur est automatiquement supprimé après exécution.

&nbsp;

## 🐋 Exercice 2 – Interactive Python Shell
### Objectif :

Lancer un conteneur Docker Python 3 en mode interactif, pour travailler dans un environnement Python temporaire.

### Contraintes :

- **Image :** ```python:3``` (officielle)

- **Script :** ```2-python.sh``` à la racine du dépôt.

- Mode interactif (```-it```)

- Le conteneur doit être supprimé automatiquement après fermeture.

### Commande Docker :

Fichier : ```2-python.sh```
```bash
#!/bin/bash
docker run --rm -it python:3
```

Rendre exécutable :
```bash
chmod +x 2-python.sh
```

Exécuter :
```bash
./2-python.sh
```

Résultat attendu : 

- Lancement d’un prompt Python :
  ```python-repl
  Python 3.x.x (default, ...)
  >>>
  ```

- Exemple d’utilisation :
  ```python
  >>> print("Hello M1 Cyber 2025")
  Hello M1 Cyber 2025
  >>> exit()
  ```

- Après la sortie (```exit()```), le conteneur est supprimé automatiquement.

&nbsp;

## 🐋 Exercice 3 – Simple Dockerfile : Curl Tool
### Objectif :

Créer un conteneur Docker exécutant ```curl``` pour récupérer une URL, en utilisant un utilisateur non-root et un argument pour l’URL.

### Contraintes :

- Dockerfile : ```3-curl.dockerfile```

- Conteneur exécuté en utilisateur non-root

- L’URL doit être passée comme argument

- Conteneur supprimé après exécution


### Dockerfile :

- **Fichier :** ```3-curl.dockerfile```

    ```dockerfile
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
    ```

- **Explications :**

    - ```FROM debian:bullseye-slim``` → base légère Debian.

    - ```RUN apt-get update && apt-get install -y curl``` → installe curl.

    - ```RUN useradd -m curluser``` → crée un utilisateur non-root.

    - ```USER curluser``` → le conteneur s’exécute en tant que curluser.

    - ```ENTRYPOINT ["curl"]``` → le conteneur exécutera toujours curl avec les arguments passés lors du ```docker run```.

### Commandes Docker :

-  Construire l’image :

    ```bash
    docker build -t my-curl -f 3-curl.dockerfile .
    ```

- Lancer le conteneur avec une URL :

    ```bash
    docker run --rm my-curl https://example.com
    ```

- Le conteneur exécutera ```curl https://example.com``` automatiquement.

- Le conteneur sera supprimé après exécution.

&nbsp;

## 🐋 Exercice 4 – The Broken Development Setup
### Objectif :

Corriger la containerisation d’une application Node.js Express mal configurée et exécutable sur le port 3000.
Le conteneur doit être sécurisé (non-root) et accessible depuis l’hôte.

### Contexte :
Tu as retrouvé les notes d’un développeur :

- Express app avec un point d’entrée ```server.js```

- ```package.json``` présent

- Port 3000 requis

- Erreurs de permission rencontrées

Le code source est dans le dossier ```broken-app/```.


### Scripts :

- **Fichier :** ```4-dev-app.dockerfile```

    ```dockerfile
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
    ```


- **Fichier :** ```4-run.sh```

    ```bash
    #!/bin/bash
    # Build et exécution du conteneur Node.js

    # Arrêt en cas d’erreur
    set -e

    # Construire l’image
    docker build -t dev-app -f 4-dev-app.dockerfile .

    # Lancer le conteneur sur le port 3000
    docker run --rm -p 3000:3000 dev-app
    ```

- Rends le script exécutable :

    ```bash
    chmod +x 4-run.sh
    ```

### Commandes de test :

- **Lancer le conteneur :** 

    ```bash
    bash 4-run.sh
    ```

- **Tester depuis ton hôte :** 

    ```bash
    curl http://localhost:3000
    ```

### Résultat obtenu :

- L’application Express répond correctement sur le port 3000 :
    ```json
    {
    "message": "Hello from the broken app!",
    "status": "fixed",
    "timestamp": "2025-10-28T10:07:27.937Z"
    }
    ```

- Aucun message d’erreur lié aux permissions

- L’exécution se fait sous un utilisateur non-root

- Le conteneur est supprimé automatiquement après arrêt

&nbsp;

## 🐋 Exercice 5 – Optimisation d’une application Go (Multi-stage build)
### Objectif
Réduire drastiquement la taille d’une image Docker pour une application Go REST API tout en conservant sa fonctionnalité, en utilisant un multi-stage build et un utilisateur non-root.

### Contexte
- L’image originale était très lourde **(800MB+)**

- L’application est simple (REST API)

- DevOps exige une image **optimisée pour production**

- Le code source est dans ```go-app/```

- L’image finale cible **< 20MB**

### Scripts :

- **Fichier :** ```5-optimized.dockerfile```

    ```dockerfile
    # ---------------------------
    # Étape 1 : Build
    # ---------------------------
    FROM golang:1.21-alpine AS builder

    WORKDIR /app

    # Copier fichiers Go et télécharger dépendances
    COPY go.mod go.sum ./
    RUN go mod download

    COPY . .

    # Compiler statiquement
    RUN CGO_ENABLED=0 GOOS=linux go build -o app

    # ---------------------------
    # Étape 2 : Runtime minimal
    # ---------------------------
    FROM scratch

    # Créer un utilisateur non-root
    USER 1001

    # Copier le binaire depuis le builder
    COPY --from=builder /app/app /app/app

    # Exposer le port utilisé par l’app
    EXPOSE 8080

    # Démarrer l’application
    ENTRYPOINT ["/app/app"]
    ```

- **Fichier :** ```5-comparison.txt```

    ```mathematica
    Before optimization:
    bloated-app   latest   800MB

    After optimization:
    optimized-app latest   13MB

    ✅ Image size reduced by ~98%
    ✅ Runs as non-root user
    ✅ Same functionality maintained
    ```

### Commandes Docker :

- Construire l’image d’origine (pour comparaison) :

    ```bash
    docker build -t bloated-app -f go-app/bloated-go-app.dockerfile go-app/
    ```

- Construire l’image optimisée :

    ```bash
    docker build -t optimized-app -f 5-optimized.dockerfile go-app/
    ```
- Vérifier les tailles :

    ```bash
    docker images | grep app
    ```
- Tester l’application optimisée :

    ```bash
    docker run --rm -p 8080:8080 optimized-app
    curl http://localhost:8080
    ```

### Résultat attendu
- Image réduite à **~13MB** (vs 800MB avant)

- L’application fonctionne **identiquement**

- Conteneur s’exécute sous **un utilisateur non-root**

- **Multi-stage build** utilisé pour séparer build et runtime

&nbsp;

## 🐋 Exercice 6 – The Disappearing Database (PostgreSQL)
### Objectif
Mettre en place une base PostgreSQL fiable et persistante avec Docker Compose, qui :

- garde les données entre les redémarrages

- crée automatiquement les tables nécessaires

### Contexte
- L’équipe QA perd les données à chaque redémarrage du conteneur

- Tables nécessaires : ```users``` et ```products```

- Base accessible sur **localhost:5432**

- L’ensemble doit être automatisé via un script

### Scripts

- **Fichier :** ```6-setup.sh```

    ```bash
    #!/bin/bash
    
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
    docker-compose up -d

    echo "PostgreSQL setup terminé. Base testdb initialisée et persistante sur le port 5432."
    ```

    Rendre le script exécutable :

    ```bash
    chmod +x 6-setup.sh
    ```

### Commandes de test

- **Lancer le script :**

    ```bash
    bash 6-setup.sh
    ```

- **Vérifier que le conteneur tourne :**

    ```bash
    docker ps
    ```

- **Vérifier les tables dans la base :**

    ```bash
    docker exec -it test-postgres psql -U postgres -d testdb -c "\dt"
    ```

- **Tester la persistance après arrêt/redémarrage :**

    ```bash
    docker stop test-postgres
    docker start test-postgres
    docker exec -it test-postgres psql -U postgres -d testdb -c "\dt"
    ```

### Résultat obtenu
- Base ```testdb``` sur **localhost:5432**

- Tables ```users``` et ```products``` créées automatiquement

    ```bash
    Schema |   Name   | Type  |  Owner   
    -------+----------+-------+----------
    public | products | table | postgres
    public | users    | table | postgres
    (2 rows)
    ```

- Données et tables persistantes entre redémarrages

- Déploiement automatisé via un simple script ```6-setup.sh```

&nbsp;

## 🐋 Exercice 7 – (à compléter)
📌 Cette section sera remplie après avoir terminé l’exercice 7.
