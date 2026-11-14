package main

import rego.v1

test_missing_tags_denied if {
	count(deny) == 1 with input as {"resource_changes": [{
		"address": "aws_s3_bucket.x", "type": "aws_s3_bucket",
		"change": {"actions": ["create"], "after": {"tags_all": {"Owner": "a"}}},
	}]}
}

test_tagged_ok if {
	count(deny) == 0 with input as {"resource_changes": [{
		"address": "aws_s3_bucket.x", "type": "aws_s3_bucket",
		"change": {"actions": ["create"], "after": {"tags_all": {"Owner": "a", "Environment": "dev", "ManagedBy": "terraform"}}},
	}]}
}

test_destroy_cluster_denied if {
	count(deny) == 1 with input as {"resource_changes": [{
		"address": "module.cluster.kind_cluster.this", "type": "kind_cluster",
		"change": {"actions": ["delete"], "after": null},
	}]}
}

test_replace_cluster_denied if {
	count(deny) == 1 with input as {"resource_changes": [{
		"address": "module.cluster.kind_cluster.this", "type": "kind_cluster",
		"change": {"actions": ["delete", "create"], "after": {}},
	}]}
}
