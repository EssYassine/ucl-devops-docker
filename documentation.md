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

## 🐋 Exercice 5 – (à compléter)
📌 Cette section sera remplie après avoir terminé l’exercice 5.
