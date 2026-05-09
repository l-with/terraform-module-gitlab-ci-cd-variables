output "ci_cd_vars" {
  description = "map of all CI/CD-variables with original names with as keys"
  value       = data.external.ci_cd_vars.result
  sensitive   = true
}

output "keys" {
  description = "sorted list of all keys"
  value       = sort(keys(data.external.ci_cd_vars.result))
}

output "count" {
  description = "number of variables"
  value       = length(data.external.ci_cd_vars.result)
}
