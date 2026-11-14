#!/usr/bin/env bash
# Cria (ou atualiza) o webhook do repo infra-live apontando para o Atlantis.
set -euo pipefail
cd "$(dirname "$0")/.."
set -a; source .env; set +a
REPO="${REPO:-patrickcmartins/infra-live}"
URL="${ATLANTIS_ATLANTIS_URL%/}/events"

payload=$(jq -n --arg url "$URL" --arg secret "$ATLANTIS_GH_WEBHOOK_SECRET" '{
  name: "web", active: true,
  events: ["issue_comment", "pull_request", "pull_request_review", "push"],
  config: {url: $url, content_type: "json", secret: $secret, insecure_ssl: "0"}
}')

id=$(gh api "repos/$REPO/hooks" --jq ".[] | select(.config.url==\"$URL\") | .id" | head -1)
if [ -n "$id" ]; then
  gh api -X PATCH "repos/$REPO/hooks/$id" --input - <<<"$payload" >/dev/null && echo "webhook $id atualizado"
else
  gh api -X POST "repos/$REPO/hooks" --input - <<<"$payload" --jq '"webhook \(.id) criado"'
fi
