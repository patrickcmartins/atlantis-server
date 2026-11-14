#!/usr/bin/env bash
# Expõe o Atlantis para o GitHub mandar webhooks.
# Use o domínio estático grátis do ngrok (dashboard.ngrok.com > Domains): a URL não muda a cada restart.
set -euo pipefail
DOMAIN="${1:?uso: $0 SEU-DOMINIO.ngrok-free.app}"
exec ngrok http --url="$DOMAIN" 4141
