# atlantis-server

O **runtime do Terraform**: o Atlantis roda em Docker no PC e executa `plan`/`apply` a partir de
comentários nos PRs do [`infra-live`](https://github.com/patrickcmartins/infra-live).

```
GitHub PR ──webhook──► ngrok ──► Atlantis (docker, host network)
                                   ├─ terraform plan/apply
                                   ├─ conftest (policies/terraform)
                                   ├─ state ──► Postgres :15432 (stacks locais)
                                   │            S3 + lockfile   (stacks AWS)
                                   └─ docker.sock ──► cria clusters kind
```

## Por que o Atlantis fica FORA do cluster?

Ele cria os clusters, então não pode morar dentro deles. Em produção, esse papel fica com um cluster de
gerenciamento ou ECS separado, e o Atlantis usa **IRSA/Pod Identity** em vez de access keys.

## Subindo

```bash
cp .env.example .env                    # preencha token, secrets, DOCKER_GID
cp secrets/aws/config.example secrets/aws/config            # depois do aws/bootstrap
cp secrets/aws/credentials.example secrets/aws/credentials
make up
./scripts/tunnel.sh SEU-DOMINIO.ngrok-free.app   # outro terminal
./scripts/register-webhook.sh
```

## O que está em `config/repos.yaml` (as regras do time de plataforma)

| Regra | Por quê |
|---|---|
| `allow_custom_workflows: false` | o repo não consegue rodar `curl \| sh` no runner que tem credencial de admin |
| `apply_requirements: [mergeable, undiverged]` | só aplica com CI verde e a branch em dia com a main |
| `repo_locks: on_plan` | dois PRs não mexem no mesmo state ao mesmo tempo |
| `policy_check` + `policies/` | tags obrigatórias e destruição de recurso protegido exigem `atlantis approve_policies` |

## Credenciais AWS

Usamos `atlantis-local`, um usuário IAM cuja **única** permissão é `sts:AssumeRole` na role `terraform-deployer`.
Mesmo que essa key vaze, ela não faz nada sozinha, e a role pode ser revogada ou restringida por IP ou ExternalId.
Isso é um compromisso de lab. Em produção o caminho é Pod Identity ou IAM Roles Anywhere.

## Testes

`make test-policies` roda os testes unitários Rego (`conftest verify`).
