# Toolchain do runner fixada e versionada no Git (nada de "funciona na minha máquina").
FROM ghcr.io/runatlantis/atlantis:v0.49.0

USER root
# O provider tehcyx/kind chama o binário `docker` para criar os nodes.
RUN apk add --no-cache docker-cli=~29 || apk add --no-cache docker-cli
# O provider kubernetes autentica no EKS via exec ("aws eks get-token"): token novo a cada
# chamada. O token estático (data aws_eks_cluster_auth) expira em 15 min e quebra applies longos.
RUN apk add --no-cache aws-cli
RUN mkdir -p /atlantis-data && chown -R atlantis:atlantis /atlantis-data
USER atlantis
