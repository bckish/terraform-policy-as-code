# Terraform Policy as Code

An original policy-as-code example that validates a small AWS network design with Open Policy Agent (OPA) and Conftest. The policies prevent public subnets and require mandatory ownership tags.

## Validate locally

```bash
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform fmt -check
terraform -chdir=terraform validate
terraform -chdir=terraform plan -out=tfplan
terraform -chdir=terraform show -json tfplan > plan.json
conftest test plan.json --policy ../policy
```

## Guardrails

- Every managed resource needs `owner` and `environment` tags.
- A subnet must not map public IPs on launch.

This is intentionally small and local-first. Extend it with remote state, organization policies, exception workflows, and CI pull-request checks before using it for production infrastructure.
