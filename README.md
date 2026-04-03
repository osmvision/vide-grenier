# Vide Grenier

Application web de gestion d'articles de vide-grenier, construite avec **PHP 8.2**, **MySQL 8** et **Docker**.  
Elle affiche la liste des articles en vente sous forme de tableau, avec le nom, la description, le prix et le vendeur.

---

## Table des matières

1. [Architecture](#architecture)
2. [Prérequis](#prérequis)
3. [Structure du projet](#structure-du-projet)
4. [Base de données](#base-de-données)
5. [Démarrage rapide](#démarrage-rapide)
   - [Développement](#développement)
   - [Production](#production)
6. [Variables d'environnement](#variables-denvironnement)
7. [Commandes utiles](#commandes-utiles)
8. [Workflow Git (GitFlow)](#workflow-git-gitflow)

---

## Architecture

```
Navigateur
    │
    ▼ HTTP
┌─────────────────────┐
│  Apache + PHP 8.2   │  ← container web (port 8080 dev / 8081 prod)
│   src/index.php     │
└────────┬────────────┘
         │ PDO / MySQL
         ▼
┌─────────────────────┐
│    MySQL 8.0        │  ← container db
│  base vide_grenier  │
└─────────────────────┘
```

- En **développement** : le code source est monté en volume (live-reload, pas de rebuild nécessaire).
- En **production** : le code est copié dans l'image Docker lors du build (image autonome, sans volume).

Les deux environnements coexistent sur la même machine grâce à des ports et des volumes de données séparés.

---

## Prérequis

| Outil | Version minimale |
|-------|-----------------|
| Docker Desktop | 24+ |
| Docker Compose | v2 (inclus dans Docker Desktop) |
| Git | 2.x |

Aucune installation PHP ou MySQL locale n'est nécessaire.

---

## Structure du projet

```
vide-grenier/
├── src/
│   └── index.php              # Page principale (liste des articles)
├── db/
│   └── schema.sql             # Création de la table + données de démo
├── data/                      # Volumes MySQL (ignorés par Git)
│   ├── dev/                   # Données de l'environnement dev
│   └── prod/                  # Données de l'environnement prod
├── Dockerfile                 # Image de production (PHP + Apache)
├── docker-compose.yml         # Stack développement (port 8080)
├── docker-compose.prod.yml    # Stack production  (port 8081)
├── start-dev.sh               # Script de démarrage DEV
├── start-prod.sh              # Script de démarrage PROD
└── .gitignore
```

---

## Base de données

Le fichier [db/schema.sql](db/schema.sql) est automatiquement exécuté au premier démarrage du container MySQL.

### Table `articles`

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | INT AUTO_INCREMENT | Identifiant unique |
| `nom` | VARCHAR(150) | Nom de l'article |
| `description` | TEXT | Description détaillée |
| `prix` | DECIMAL(8,2) | Prix en euros |
| `vendeur` | VARCHAR(100) | Nom du vendeur |
| `created_at` | DATETIME | Date d'ajout (auto) |

Le script insère également **5 articles de démo** au premier lancement (vélo, table, livres, appareil photo, vase).

---

## Démarrage rapide

### Développement

Environnement avec **live-reload** : toute modification dans `src/` est immédiatement visible sans rebuild.

```bash
./start-dev.sh
```

ou manuellement :

```bash
docker compose -f docker-compose.yml up --build -d
```

Application disponible sur : **http://localhost:8080**

```bash
# Voir les logs en temps réel
docker compose logs -f

# Arrêter
docker compose down
```

---

### Production

L'image est buildée à partir du [Dockerfile](Dockerfile) : le code est copié à l'intérieur (pas de volume).

```bash
./start-prod.sh
```

ou manuellement :

```bash
docker compose -f docker-compose.prod.yml build --no-cache
docker compose -f docker-compose.prod.yml up -d
```

Application disponible sur : **http://localhost:8081**

```bash
# Voir les logs en temps réel
docker compose -f docker-compose.prod.yml logs -f

# Arrêter
docker compose -f docker-compose.prod.yml down
```

> Les deux environnements peuvent tourner en même temps (ports différents : 8080 et 8081) et leurs données MySQL sont stockées séparément dans `data/dev/` et `data/prod/`.

---

## Variables d'environnement

Les variables sont définies directement dans les fichiers `docker-compose*.yml`.  
Pour un déploiement réel, il est recommandé de les externaliser dans un fichier `.env` (déjà ignoré par Git).

| Variable | Valeur par défaut | Description |
|----------|-------------------|-------------|
| `DB_HOST` | `db-dev` / `db-prod` | Hostname du container MySQL |
| `DB_NAME` | `vide_grenier` | Nom de la base de données |
| `DB_USER` | `app_user` | Utilisateur MySQL |
| `DB_PASSWORD` | `secret` | Mot de passe MySQL |

---

## Commandes utiles

```bash
# Voir les containers en cours
docker ps

# Se connecter à MySQL (dev)
docker exec -it vide-grenier-db-dev mysql -u app_user -psecret vide_grenier

# Réinitialiser les données (supprime le volume et recrée)
docker compose down -v
docker compose up --build -d

# Rebuild forcé de l'image prod
docker compose -f docker-compose.prod.yml build --no-cache
```

---

## Workflow Git (GitFlow)

Ce projet suit le modèle **GitFlow** avec deux branches permanentes :

| Branche | Rôle |
|---------|------|
| `main` | Code stable, en production, taggué |
| `dev` | Intégration des développements en cours |

### Développer une fonctionnalité

```bash
# 1. Partir de dev
git checkout dev
git pull origin dev

# 2. Créer une branche de feature
git checkout -b feat/nom-de-la-feature

# 3. Coder, puis commiter
git add .
git commit -m "feat: description de la modification"

# 4. Merger dans dev
git checkout dev
git merge --no-ff feat/nom-de-la-feature
git push origin dev

# 5. Supprimer la branche locale
git branch -d feat/nom-de-la-feature
```

### Créer une release

```bash
# 1. Créer la branche de release depuis dev
git checkout -b release/1.1.0

# 2. Merger dans main
git checkout main
git merge --no-ff release/1.1.0
git tag -a v1.1.0 -m "Version 1.1.0"
git push origin main --tags

# 3. Resynchroniser dev
git checkout dev
git merge --no-ff release/1.1.0
git push origin dev

# 4. Supprimer la branche release
git branch -d release/1.1.0
```

### Version simplifiée (sans branche release)

```bash
git checkout main
git merge --no-ff dev
git tag -a v1.1.0 -m "Version 1.1.0"
git push origin main dev --tags
```
