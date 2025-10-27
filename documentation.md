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
#### Objectif :

Faire tourner un conteneur Docker qui affiche un message personnalisé puis se supprime automatiquement après son exécution.

#### Contraintes :

- **Image :** ```anthonyjhoiro/whalesay```

- **Message :** "Hello M1 Cyber 2025"


- **Script :** ```1-hello-whale.sh``` à la racine du dépôt.

- Le conteneur doit être supprimé après exécution.

#### Commande Docker de base :

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

Résultat attendu : 
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
#### Objectif :

Lancer un conteneur Docker Python 3 en mode interactif, pour travailler dans un environnement Python temporaire.

#### Contraintes :

- **Image :** ```python:3``` (officielle)

- **Script :** ```2-python.sh``` à la racine du dépôt.

- Mode interactif (```-it```)

- Le conteneur doit être supprimé automatiquement après fermeture.

#### Commande Docker :

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

## 🐋 Exercice 3 – (à compléter)
📌 Cette section sera remplie après avoir terminé l’exercice 3.
