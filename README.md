# AWS federation for GitLab Actions

Terraform module to configure GitLab as an IAM OIDC identity provider in
AWS. This enables GitLab to access resources within an AWS account
without requiring long-lived credentials to be stored as GitLab secrets.

## 🔨 Getting started

### Installation and usage

Refer to the [complete example] to view all the available configuration options.
The following snippet shows the minimum required configuration to create a
working OIDC connection between GitLab Actions and AWS.

```terraform
provider "aws" {
  region = var.region
}

module "aws_oidc_gitlab" {
  source  = "modules/glitchcowboy/terraform-aws-oidc-gitlab" #aint gonna work
  version = "0.1.0"

  gitlab_repositories = [
    "group/project",
    "another-group/another-project:ref_type:branch:ref:main",
  ]
}
```

The following demonstrates how to use GitLab Actions once the Terraform module
has been applied to your AWS account. The action receives a JSON Web Token (JWT)
from the GitLab OIDC provider and then requests an access token from AWS.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                      | Version |
|---------------------------------------------------------------------------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | ~> 4.0  |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                 | Type        |
|------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_iam_openid_connect_provider.gitlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider)    | resource    |
| [aws_iam_role.gitlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                          | resource    |
| [aws_iam_role_policy_attachment.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)       | resource    |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)      | resource    |
| [aws_iam_role_policy_attachment.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)   | resource    |
| [aws_iam_openid_connect_provider.gitlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                                    | data source |

## Inputs

| Name                                                                                                                            | Description                                                              | Type           | Default                                      | Required |
|---------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|----------------|----------------------------------------------|:--------:|
| <a name="input_attach_admin_policy"></a> [attach\_admin\_policy](#input\_attach\_admin\_policy)                                 | Flag to enable/disable the attachment of the AdministratorAccess policy. | `bool`         | `false`                                      |    no    |
| <a name="input_attach_read_only_policy"></a> [attach\_read\_only\_policy](#input\_attach\_read\_only\_policy)                   | Flag to enable/disable the attachment of the ReadOnly policy.            | `bool`         | `true`                                       |    no    |
| <a name="input_create_oidc_provider"></a> [create\_oidc\_provider](#input\_create\_oidc\_provider)                              | Flag to enable/disable the creation of the GitLab OIDC provider.         | `bool`         | `true`                                       |    no    |
| <a name="input_enabled"></a> [enabled](#input\_enabled)                                                                         | Flag to enable/disable the creation of resources.                        | `bool`         | `true`                                       |    no    |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies)                           | Flag to force detachment of policies attached to the IAM role.           | `string`       | `false`                                      |    no    |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories)                                   | List of GitLab organization/repository names.                            | `list(string)` | n/a                                          |   yes    |
| <a name="input_github_thumbprint"></a> [github\_thumbprint](#input\_github\_thumbprint)                                         | GitLab OpenID TLS certificate thumbprint.                                | `string`       | `"6938fd4d98bab03faadb97b34396831e3780aea1"` |    no    |
| <a name="iam_role_inline_policies"></a> [iam\_role\_inline\_policies](#iam\_role\_inline\_policies)                             | Inline policies map with policy name as key and json as value.           | `map(string)`  | `{}`                                         |    no    |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name)                                                   | Name of the IAM role.                                                    | `string`       | `"github"`                                   |    no    |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path)                                                   | Path to the IAM role.                                                    | `string`       | `"/"`                                        |    no    |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the permissions boundary to be used by the IAM role.              | `string`       | `""`                                         |    no    |
| <a name="input_iam_role_policy_arns"></a> [iam\_role\_policy\_arns](#input\_iam\_role\_policy\_arns)                            | List of IAM policy ARNs to attach to the IAM role.                       | `list(string)` | `[]`                                         |    no    |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration)                              | Maximum session duration in seconds.                                     | `number`       | `3600`                                       |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                  | Map of tags to be applied to all resources.                              | `map(string)`  | `{}`                                         |    no    |

## Outputs

| Name                                                                         | Description          |
|------------------------------------------------------------------------------|----------------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the IAM role. |
<!-- END_TF_DOCS -->

## References

* [Configuring OpenID Connect in Amazon Web Services]
* [Creating OpenID Connect (OIDC) identity providers]
* [Obtaining the thumbprint for an OpenID Connect Identity Provider]

## License
((shamelessly borrowed and modified for gitlab by Barak Griffis 24MAY2022))


© 2021 [Daniel Morris](https://unfun.co)  
Made available under the terms of the [Apache License 2.0].

[Apache License 2.0]: LICENSE.md
[Complete example]: examples/complete
[Configuring OpenID Connect in Amazon Web Services]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
[Creating OpenID Connect (OIDC) identity providers]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
[Make]: https://www.gnu.org/software/make/
[Obtaining the thumbprint for an OpenID Connect Identity Provider]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
[Terraform]: https://www.terraform.io
