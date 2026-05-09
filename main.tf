variable "exclude" {
  description = "GitLab CI/CD-variables to be excluded, for instance contaning secrets (CI_JOB_TOKEN, CI_REGISTRY_PASSWORD, CI_DEPLOY_PASSWORD, CI_REPOSITORY_URL)"
  type        = set(string)
  default = []
  
}

variable "extra_prefixes" {
  description = "additional prefixes of environment variable to be included"
  type        = list(string)
  default     = []
}

data "external" "ci_cd_vars" {
  program = [
    "python3", "-c", <<-PYTHON
import os, json

prefixes = tuple(["CI_", "GITLAB_", "CHAT_"] + ${jsonencode(var.extra_prefixes)})
exclude  = set(${jsonencode(tolist(var.exclude))})

result = {
  key: value
  for key, value in os.environ.items()
  if  key.startswith(prefixes)
  and key not in exclude
  and "\n" not in value   # external erwartet flaches JSON
  and value != ""
}

print(json.dumps(result))
PYTHON
  ]
}


