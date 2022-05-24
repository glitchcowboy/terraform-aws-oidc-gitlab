locals {
  gitlab_organizations = [for repo in var.gitlab_repositories : split("/", repo)[0]]
  oidc_provider_arn    = var.enabled ? (var.create_oidc_provider ? aws_iam_openid_connect_provider.gitlab[0].arn : data.aws_iam_openid_connect_provider.gitlab[0].arn) : ""
  partition            = data.aws_partition.current.partition
}

resource "aws_iam_role" "gitlab" {
  count = var.enabled ? 1 : 0

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  description           = "Role assumed by the GitLab OIDC provider."
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  name                  = var.iam_role_name
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary
  tags                  = var.tags

  dynamic "inline_policy" {
    for_each = var.iam_role_inline_policies

    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = var.enabled && var.attach_admin_policy ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.gitlab[0].id
}

resource "aws_iam_role_policy_attachment" "read_only" {
  count = var.enabled && var.attach_read_only_policy ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.gitlab[0].id
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.enabled ? length(var.iam_role_policy_arns) : 0

  policy_arn = var.iam_role_policy_arns[count.index]
  role       = aws_iam_role.gitlab[0].id
}

resource "aws_iam_openid_connect_provider" "gitlab" {
  count = var.enabled && var.create_oidc_provider ? 1 : 0

  client_id_list = concat(
    [for org in local.gitlab_organizations : "https://gitlab.com"]
  )

  tags            = var.tags
  thumbprint_list = [var.gitlab_thumbprint]
  url             = "https://gitlab.com"
}
