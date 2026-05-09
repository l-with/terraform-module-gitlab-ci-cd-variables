variable "exclude" {
  description = "GitLab CI/CD-variables to be excluded, for instance contaning secrets (CI_JOB_TOKEN, CI_REGISTRY_PASSWORD, CI_DEPLOY_PASSWORD, CI_REPOSITORY_URL)"
  type        = set(string)
  default = []
  
}

variable "allow" {
    description = "GitLab CI/CD-variables"
}

variable "extra_prefixes" {
  description = "additional prefixes of environment variable to be included"
  type        = list(string)
  default     = []
}
