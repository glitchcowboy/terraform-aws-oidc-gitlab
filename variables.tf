variable "attach_admin_policy" {
  default     = false
  description = "Flag to enable/disable the attachment of the AdministratorAccess policy."
  type        = bool
}

variable "attach_read_only_policy" {
  default     = true
  description = "Flag to enable/disable the attachment of the ReadOnly policy."
  type        = bool
}

variable "create_oidc_provider" {
  default     = true
  description = "Flag to enable/disable the creation of the GitLab OIDC provider."
  type        = bool
}

variable "enabled" {
  default     = true
  description = "Flag to enable/disable the creation of resources."
  type        = bool
}

variable "force_detach_policies" {
  default     = false
  description = "Flag to force detachment of policies attached to the IAM role."
  type        = string
}

variable "gitlab_repositories" {
  description = "List of GitLab groups/subgroup/repository names authorized to assume the role."
  type        = list(string)

  #validation {
  // Ensures each element of gitlab_repositories list matches the
  // organization/repository format used by GitLab.
  #  condition = length([
  #    for repo in var.gitlab_repositories : 1
  #    if length(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/-]+|\\*)$", repo)) > 0
  #  ]) == length(var.gitlab_repositories)
  #  error_message = "Repositories must be specified in the organization/repository format."
  #}
}

// Refer to the README for information on obtaining the thumbprint.
// This is specified as a variable to allow it to be updated quickly if it is
// unexpectedly changed by GitLab.
// See: https://gitlab.blog/changelog/2022-01-13-gitlab-actions-update-on-oidc-based-deployments-to-aws/
variable "gitlab_thumbprint" {
  default     = "b3dd7606d2b5a8b4a13771dbecc9ee1cecafa38a"
  description = "GitLab OpenID TLS certificate thumbprint."
  type        = string
}

variable "iam_role_name" {
  default     = "gitlab"
  description = "Name of the IAM role to be created. This will be assumable by GitLab."
  type        = string
}

variable "iam_role_path" {
  default     = "/"
  description = "Path under which to create IAM role."
  type        = string
}

variable "iam_role_permissions_boundary" {
  default     = ""
  description = "ARN of the permissions boundary to be used by the IAM role."
  type        = string
}

variable "iam_role_policy_arns" {
  default     = []
  description = "List of IAM policy ARNs to attach to the IAM role."
  type        = list(string)
}

variable "iam_role_inline_policies" {
  default     = {}
  description = "Inline policies map with policy name as key and json as value."
  type        = map(string)
}

variable "max_session_duration" {
  default     = 3600
  description = "Maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Maximum session duration must be between 3600 and 43200 seconds."
  }
}

variable "tags" {
  default     = {}
  description = "Map of tags to be applied to all resources."
  type        = map(string)
}
