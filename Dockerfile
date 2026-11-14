# Toolchain do runner fixada e versionada no Git (nada de "funciona na minha máquina").
FROM ghcr.io/runatlantis/atlantis:v0.49.0

USER root
# O provider tehcyx/kind chama o binário `docker` para criar os nodes.
RUN apk add --no-cache docker-cli=~29 || apk add --no-cache docker-cli
USER atlantis
