# KMS

Create and manage KMS keys using AWS best-practices.

## Key Rotation

Key roation is enabled by default. The default rotation is set to 365 days. This is the bare minimum that is recommended. Ideally, keys would be rotated between every 30 and 90 days.

## Key Spec

The default key spec (`var.key_spec`) is set to `SYMMETRIC_DEFAULT` with the key usage (`var.key_usage`) set to `
`. Read more on this in the [AWS Documentation](https://docs.aws.amazon.com/kms/latest/developerguide/asymmetric-key-specs.html#key-spec-symmetric-default).

## Deletion Window

The default deletion window (`var.deletion_window_in_days`) is set to 30 days. This is the minimum recommended to prevent unauthorized key deletions.

## Key Policy

The default key policy (`var.policy`) is overly permissive. One should specify a custom key policy for every KMS key and only allow the required permissions. See the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)for examples on setting key administrators and users which is also preferred. More information can also be found in the [AWS KMS Default Key Policy Documentation](https://docs.aws.amazon.com/kms/latest/developerguide/).

## Further Reading

- [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)
- [AWS Key Policy Documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)
  - [AWS KMS Default Key Policy Documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html)
- [Custom KMS Key Stores](https://docs.aws.amazon.com/kms/latest/developerguide/create-cmk-keystore.html)
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_std"></a> [std](#module\_std) | github.com/clearscale/tf-standards.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | (Optional). Current cloud provider account info. | <pre>object({<br>    key      = optional(string, "current")<br>    provider = optional(string, "aws")<br>    id       = optional(string, "*") <br>    name     = string<br>    region   = optional(string, null)<br>  })</pre> | <pre>{<br>  "id": "*",<br>  "name": "shared"<br>}</pre> | no |
| <a name="input_alias"></a> [alias](#input\_alias) | (Optional). The alias is generated automatically based on the standard parameters including `var.name`. This value allows the alias to be overridden. | `string` | `null` | no |
| <a name="input_arn_partition"></a> [arn\_partition](#input\_arn\_partition) | (Optional). Override the partition to specify in the ARN (aws or aws-us-gov). | `string` | `null` | no |
| <a name="input_bypass_policy_lockout_safety_check"></a> [bypass\_policy\_lockout\_safety\_check](#input\_bypass\_policy\_lockout\_safety\_check) | (Optional). A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable. Do not set this value to true indiscriminately. For more information, refer to the scenario in the Default Key Policy section in the AWS Key Management Service Developer Guide. The default value is false. | `bool` | `false` | no |
| <a name="input_client"></a> [client](#input\_client) | (Optional). Name of the client | `string` | `"ClearScale"` | no |
| <a name="input_custom_key_store_id"></a> [custom\_key\_store\_id](#input\_custom\_key\_store\_id) | (Optional). ID of the KMS Custom Key Store where the key will be stored instead of KMS (e.g., CloudHSM). | `string` | `null` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | (Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC\_DEFAULT, RSA\_2048, RSA\_3072, RSA\_4096, HMAC\_256, ECC\_NIST\_P256, ECC\_NIST\_P384, ECC\_NIST\_P521, or ECC\_SECG\_P256K1. Defaults to SYMMETRIC\_DEFAULT. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_prevention"></a> [deletion\_prevention](#input\_deletion\_prevention) | (Optional). Prevent Terraform from deleting the key on terraform destroy? | `bool` | `false` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | (Optional). Deletion window in days for key deletion. | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional). The description of the KMS key. | `string` | `"Custom KMS key."` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | (Optional). Enable key rotation? | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional). Specifies whether the key is enabled. Defaults to true. | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | (Optional). Name of the current environment. | `string` | `"dev"` | no |
| <a name="input_key_spec"></a> [key\_spec](#input\_key\_spec) | (Optional). Key spec for the KMS key. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | (Optional). Key usage for the KMS key. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_multi_region"></a> [multi\_region](#input\_multi\_region) | (Optional). Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required). The name (e.g., alias) of the KMS key. | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | The IAM policy for the KMS key. An over permissive policy is used as a default. It's best practice to set this. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Optional). Prefix override for all generated naming conventions. | `string` | `"cs"` | no |
| <a name="input_project"></a> [project](#input\_project) | (Optional). Name of the client project. | `string` | `"pmod"` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional). Name of the region. | `string` | `"us-west-1"` | no |
| <a name="input_rotation_period_in_days"></a> [rotation\_period\_in\_days](#input\_rotation\_period\_in\_days) | (Optional). Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive). The key should be rotated at least once per year at a minimum. | `number` | `365` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional). A map of tags to assign to the resources. | `map(string)` | `null` | no |
| <a name="input_xks_key_id"></a> [xks\_key\_id](#input\_xks\_key\_id) | (Optional). Identifies the external key that serves as key material for the KMS key in an external key store. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->