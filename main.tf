data "external" "ci_cd_vars" {
  program = [
    "python3", "-c", <<-PYTHON
import os, json

prefixes  = tuple(["CI_", "GITLAB_", "CHAT_"] + ${jsonencode(var.extra_prefixes)})
allowlist = set(${jsonencode(tolist(var.allow))})
exclude   = set(${jsonencode(tolist(var.exclude))})

def include(key):
    if allowlist:
        return key in allowlist
    return key.startswith(prefixes) and key not in exclude

result = {
    key: value
    for key, value in os.environ.items()
    if  include(key)
    and "\n" not in value  # external requires flat JSON
    and value != ""
}

print(json.dumps(result))
PYTHON
  ]
}


