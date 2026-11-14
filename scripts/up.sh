#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f .env ] || { echo "Crie o .env a partir do .env.example"; exit 1; }
for f in config credentials; do
  [ -f "secrets/aws/$f" ] || cp "secrets/aws/$f.example" "secrets/aws/$f"
done
docker compose up -d --build
echo "Atlantis: http://localhost:4141   State DB: 127.0.0.1:15432"
