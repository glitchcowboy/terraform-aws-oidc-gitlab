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

provider "aws" {
  region = var.region
}

module "aws_oidc_gitlab" {
  source = "../../"

  enabled = var.enabled

  attach_admin_policy           = var.attach_admin_policy
  attach_read_only_policy       = var.attach_read_only_policy
  create_oidc_provider          = var.create_oidc_provider
  force_detach_policies         = var.force_detach_policies
  gitlab_thumbprint             = var.gitlab_thumbprint
  iam_role_name                 = var.iam_role_name
  iam_role_path                 = var.iam_role_path
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_policy_arns          = var.iam_role_policy_arns
  gitlab_repositories           = var.gitlab_repositories
  max_session_duration          = var.max_session_duration
  tags                          = var.tags

  iam_role_inline_policies = {
    "example_inline_policy" : data.aws_iam_policy_document.example.json
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["*"]
  }
}
