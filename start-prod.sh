#!/usr/bin/env bash
# ── Build et lancement de l'environnement de production ──────────────────────
set -e

echo ">>> Build de l'image de production..."
docker compose -f docker-compose.prod.yml build --no-cache

echo ""
echo ">>> Démarrage de l'environnement PROD (port 8081)..."
docker compose -f docker-compose.prod.yml up -d

echo ""
echo ">>> Environnement PROD prêt !"
echo "    Application : http://localhost:8081"
echo "    Logs        : docker compose -f docker-compose.prod.yml logs -f"
echo "    Arrêt       : docker compose -f docker-compose.prod.yml down"
