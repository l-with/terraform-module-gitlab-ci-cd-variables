variable "exclude" {
  description = <<-DESC
    Variable names to exclude from the output (e.g. short-lived or
    security-sensitive variables). Ignored when 'allowlist' is non-empty.
  DESC
  type        = set(string)
  default     = []

}

variable "allow" {
  description = <<-DESC
    Explicit allowlist of GitLab CI/CD variable names to include in the output.
    When non-empty, only variables whose names are in this list are returned.
    Takes precedence over 'exclude'. When empty (default), all variables
    matching the configured prefixes are included (minus 'exclude').
  DESC
  type        = set(string)
  default     = []
}

variable "extra_prefixes" {
  description = "additional prefixes of environment variable to be included"
  type        = list(string)
  default     = []
}
