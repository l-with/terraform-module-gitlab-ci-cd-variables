# Terraform Module GitLab CI/CD Variables


Reads all GitLab Predefined CI/CD Variables at runtime from the Runner
and exposes them as a Terraform output — no API call, no state entry,
no provider required.

## How It Works

An `external` data source invokes a Python snippet on the Runner that
collects all environment variables with the prefixes `CI_`, `GITLAB_`,
and `CHAT_` and returns them as a flat JSON object. Terraform turns this
into a map that can be used directly in the calling module.

```
GitLab Runner (CI/CD variables)
        │
        ▼
data "external" (python3)
        │
        ▼
output "env"  →  module.ci_vars.env["CI_PROJECT_ID"]
```

## Terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [external_external.ci_cd_vars](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allow"></a> [allow](#input\_allow) | GitLab CI/CD-variables | `any` | n/a | yes |
| <a name="input_exclude"></a> [exclude](#input\_exclude) | GitLab CI/CD-variables to be excluded, for instance contaning secrets (CI\_JOB\_TOKEN, CI\_REGISTRY\_PASSWORD, CI\_DEPLOY\_PASSWORD, CI\_REPOSITORY\_URL) | `set(string)` | `[]` | no |
| <a name="input_extra_prefixes"></a> [extra\_prefixes](#input\_extra\_prefixes) | additional prefixes of environment variable to be included | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ci_cd_vars"></a> [ci\_cd\_vars](#output\_ci\_cd\_vars) | map of all CI/CD-variables with original names with as keys |
| <a name="output_count"></a> [count](#output\_count) | number of variables |
| <a name="output_keys"></a> [keys](#output\_keys) | sorted list of all keys |
<!-- END_TF_DOCS -->
