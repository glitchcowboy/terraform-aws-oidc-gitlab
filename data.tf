// Copyright © 2021 Daniel Morris
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Copyright © Barak Griffis
// 2022-May-25 Modified for GitLab

data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test = "StringLike"
      values = [
        "project_path:${var.gitlab_repositories[0]}"
      ]
      variable = "gitlab.com:sub"
    }

    principals {
      identifiers = [local.oidc_provider_arn]
      type        = "Federated"
    }
  }

  version = "2012-10-17"
}

data "aws_iam_openid_connect_provider" "gitlab" {
  count = var.enabled && !var.create_oidc_provider ? 1 : 0

  url = "https://gitlab.com"
}
