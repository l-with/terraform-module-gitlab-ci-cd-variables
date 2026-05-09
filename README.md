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
GitLab Runner (env vars)
        │
        ▼
data "external" (python3)
        │
        ▼
output "env"  →  module.ci_vars.env["CI_PROJECT_ID"]
```

## Requirements

- Terraform runs **inside a GitLab CI/CD pipeline** (Runner)
- `python3` available on the Runner (standard for most images)
- Terraform ≥ 1.0, provider `hashicorp/external ~> 2.0`

## Usage

```hcl
module "ci_vars" {
  source = "./modules/gitlab_ci_vars"
}

locals {
  project_id = module.ci_vars.env["CI_PROJECT_ID"]
  commit_sha = module.ci_vars.env["CI_COMMIT_SHA"]
}
```

With optional parameters:

```hcl
module "ci_vars" {
  source = "./modules/gitlab_ci_vars"

  exclude = [
    "CI_JOB_TOKEN",
    "CI_REGISTRY_PASSWORD",
    "CI_DEPLOY_PASSWORD",
    "CI_REPOSITORY_URL",
  ]

  extra_prefixes = ["MY_CUSTOM_"]
}
```

## Inputs

| Name             | Type           | Default | Description                                        |
|------------------|----------------|---------|----------------------------------------------------|
| `exclude`        | `set(string)`  | `[]`    | Variable names to exclude from the output          |
| `extra_prefixes` | `list(string)` | `[]`    | Additional prefixes to include                     |

## Outputs

| Name    | Type           | Description                                              |
|---------|----------------|----------------------------------------------------------|
| `env`   | `map(string)`  | All collected variables, key = original variable name    |
| `keys`  | `list(string)` | Sorted list of all available keys                        |
| `count` | `number`       | Number of collected variables                            |

## Access Patterns

```hcl
# Direct — when the variable is guaranteed to exist
module.ci_vars.env["CI_PROJECT_ID"]

# With fallback — when the variable is optional
lookup(module.ci_vars.env, "CI_ENVIRONMENT_NAME", "unknown")
```

## Notes

### Exclude Short-Lived Variables

Some predefined variables are job-specific and change with every run.
They should generally **not** be reused or persisted:

| Variable               | Reason                                      |
|------------------------|---------------------------------------------|
| `CI_JOB_TOKEN`         | Expires when the job ends                   |
| `CI_REGISTRY_PASSWORD` | Identical to `CI_JOB_TOKEN`                 |
| `CI_DEPLOY_PASSWORD`   | Short-lived deploy token                    |
| `CI_REPOSITORY_URL`    | Contains a token embedded in the URL        |

### Included Prefixes (Default)

| Prefix    | Examples                                             |
|-----------|------------------------------------------------------|
| `CI_`     | `CI_PROJECT_ID`, `CI_COMMIT_SHA`, `CI_PIPELINE_ID`  |
| `GITLAB_` | `GITLAB_USER_LOGIN`, `GITLAB_USER_EMAIL`             |
| `CHAT_`   | `CHAT_CHANNEL`, `CHAT_INPUT` (ChatOps pipelines)    |

### Multi-Line Values

Variables with newlines in their value are automatically excluded because
the `external` data source only handles flat JSON. For such values
(e.g. SSH keys, certificates) use direct environment variable access
via `var` or `local-exec` instead.

## File Structure

```
modules/
  gitlab_ci_vars/
    main.tf       # external data source + input variables
    outputs.tf    # env, keys, count
    README.md     # this file
```