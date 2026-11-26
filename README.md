# Terraform Policy as Code

An original policy-as-code example that validates a small AWS network design with Open Policy Agent (OPA) and Conftest. The policies prevent public subnets and require mandatory ownership tags.

## Validate locally

```bash
terraform -chdir=terraform init -backend=false -input=false
terraform -chdir=terraform fmt -check
terraform -chdir=terraform validate
terraform -chdir=terraform test
docker run --rm -v "$PWD/policy:/policy:ro" openpolicyagent/opa:1.22.4 test /policy -v
```

## Guardrails

- Every managed resource in this lab needs nonempty `owner` and `environment` tags; missing tag objects are rejected. Deletions and data resources are excluded.
- A subnet must not map public IPs on launch.

This is intentionally small and local-first. Extend it with remote state, organization policies, exception workflows, and CI pull-request checks before using it for production infrastructure.

Verified 26 November 2026: Terraform validation and one mocked network plan passed, and all four OPA tests passed against synthetic Terraform plan shapes, including missing/blank tags and public subnet rejection. No real Terraform plan or apply was executed. A real plan-policy integration and exceptions for non-taggable resource types require separate validation before production use.
