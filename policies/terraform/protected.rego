package main

import rego.v1

# Recursos cuja destruição exige aprovação explícita de um policy owner:
#   comente "atlantis approve_policies" no PR.
protected_types := {
	"kind_cluster",
	"aws_eks_cluster",
	"aws_s3_bucket",
	"aws_iam_openid_connect_provider",
}

deny contains msg if {
	some rc in input.resource_changes
	rc.type in protected_types
	"delete" in rc.change.actions
	msg := sprintf("destruição de recurso protegido: %s (requer 'atlantis approve_policies')", [rc.address])
}
