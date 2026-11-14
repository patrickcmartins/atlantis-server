.PHONY: up down logs test-policies
up:            ; ./scripts/up.sh
down:          ; docker compose down
logs:          ; docker compose logs -f atlantis
test-policies:
	docker run --rm -v $(PWD)/policies:/policies --entrypoint conftest ghcr.io/runatlantis/atlantis:v0.49.0 verify -p /policies/terraform
