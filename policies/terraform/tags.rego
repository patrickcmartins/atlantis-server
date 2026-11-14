package main

import rego.v1

# Todo recurso AWS precisa das tags de ownership/custo.
# (Via default_tags no provider: tags_all já vem preenchido no plan.)
required_tags := {"Owner", "Environment", "ManagedBy"}

deny contains msg if {
	some rc in input.resource_changes
	startswith(rc.type, "aws_")
	some action in rc.change.actions
	action in {"create", "update"}
	tags := object.get(rc.change.after, "tags_all", null)
	is_object(tags)
	present := {k | some k, _ in tags}
	missing := required_tags - present
	count(missing) > 0
	msg := sprintf("%s sem tags obrigatórias: %v", [rc.address, missing])
}
