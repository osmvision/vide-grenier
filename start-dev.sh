#!/usr/bin/env bash
# ── Lancement de l'environnement de développement ────────────────────────────
set -e

echo ">>> Démarrage de l'environnement DEV (port 8080)..."
docker compose -f docker-compose.yml up --build -d

echo ""
echo ">>> Environnement DEV prêt !"
echo "    Application : http://localhost:8080"
echo "    Logs        : docker compose logs -f"
echo "    Arrêt       : docker compose down"
