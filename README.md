# KMS

Create and manage KMS keys using AWS best-practices.

## Defaults

| Rule                                                                                                            | Supported | Notes                                                                                                                   |
|-----------------------------------------------------------------------------------------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------|
| Support a default key policy                                                                                    | Y         | See `var.policy`                                                                                                        |
| Encryption keys must be rotated on a yearly basis at a minimum                                                  | Y         | See `var.rotation_period_in_days`. Default is 365 days.                                                                 |
| Symmetric encryption keys should be used when sender and recipient of encrypted data have valid credentials to call AWS KMS | Y         | See `var.customer_master_key_spec` and `var.key_usage`.                                                                 |
| KMS encryption keys must be in enabled state to properly encrypt and decrypt the resources                      | Y         | See `var.enabled`, `var.policy`, and `var.key_usage`                                                                    |
| CMK waiting period should be set to 30 days to protect the keys from unauthorized / unintended deletion         | Y         | See `var.deletion_window_in_days`. Default is 30.                                                                       |
| Retain production KMS keys                                                                                      | Y         | Not supported directly, but attaching a key policy (`var.policy`) that does not allow `KMS:Delete` will prevent deletions. The default policy (enabled when `var.policy == null`). Prevents deletion for all non-administrators and key owners. |
| Create SSM parameter for KEY ID                                                                                 | Y         | The key ID is stored in the parameter store under a generated name starting with `/kms/(env) prefix. The name of the SSM Parameter can be changed using `var.ssm_parameter_name`. |

### Key Rotation

Key roation is enabled by default. The default rotation is set to 365 days. This is the bare minimum that is recommended. Ideally, keys would be rotated between every 30 and 90 days.

### Key Usage

The default key usage (`var.key_usage`) set to `ENCRYPT_DECRYPT`.

### Deletion Window

The default deletion window (`var.deletion_window_in_days`) is set to 30 days. This is the minimum recommended to prevent unauthorized key deletions.

### Key Policy

The default key policy (`var.policy`) is not overly permissive, but should be customized. Consider specifying a custom key policy for every KMS key and only allow the required permissions. See the [Terraform documentation](https://github.com/terraform-aws-modules/terraform-aws-kms/blob/master/examples/complete/main.tf) for examples on setting key administrators and users which is also preferred. More information can also be found in the [AWS KMS Default Key Policy Documentation](https://docs.aws.amazon.com/kms/latest/developerguide/).

## Further Reading

- [Module documentation](https://registry.terraform.io/modules/terraform-aws-modules/kms/aws/latest)
- [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)
- [AWS Key Policy Documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)
  - [AWS KMS Default Key Policy Documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html)
- [Custom KMS Key Stores](https://docs.aws.amazon.com/kms/latest/developerguide/create-cmk-keystore.html)
- 
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.55.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | ~> 3.1.0 |
| <a name="module_std"></a> [std](#module\_std) | github.com/clearscale/tf-standards.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | (Optional). Current cloud provider account info. | <pre>object({<br>    key      = optional(string, "current")<br>    provider = optional(string, "aws")<br>    id       = optional(string, "*") <br>    name     = string<br>    region   = optional(string, null)<br>  })</pre> | <pre>{<br>  "id": "*",<br>  "name": "shared"<br>}</pre> | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | (Optional). A list of aliases to create. Note - due to the use of `toset()`, values must be static strings and not computed values. | `list(string)` | `[]` | no |
| <a name="input_aliases_use_name_prefix"></a> [aliases\_use\_name\_prefix](#input\_aliases\_use\_name\_prefix) | (Optional). Determines whether the alias name is used as a prefix. | `bool` | `false` | no |
| <a name="input_arn_partition"></a> [arn\_partition](#input\_arn\_partition) | (Optional). Override the partition to specify in the ARN (aws or aws-us-gov). | `string` | `null` | no |
| <a name="input_bypass_policy_lockout_safety_check"></a> [bypass\_policy\_lockout\_safety\_check](#input\_bypass\_policy\_lockout\_safety\_check) | (Optional). A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable. | `bool` | `false` | no |
| <a name="input_client"></a> [client](#input\_client) | (Optional). Name of the client | `string` | `"ClearScale"` | no |
| <a name="input_computed_aliases"></a> [computed\_aliases](#input\_computed\_aliases) | (Optional). A map of aliases to create. Values provided via the `name` key of the map can be computed from upstream resources. | `any` | `{}` | no |
| <a name="input_create_external"></a> [create\_external](#input\_create\_external) | (Optional). Determines whether an external CMK (externally provided material) will be created or a standard CMK (AWS provided material). | `bool` | `false` | no |
| <a name="input_create_replica"></a> [create\_replica](#input\_create\_replica) | (Optional). Determines whether a replica standard CMK will be created (AWS provided material). | `bool` | `false` | no |
| <a name="input_create_replica_external"></a> [create\_replica\_external](#input\_create\_replica\_external) | (Optional). Determines whether a replica external CMK will be created (externally provided material). | `bool` | `false` | no |
| <a name="input_custom_key_store_id"></a> [custom\_key\_store\_id](#input\_custom\_key\_store\_id) | (Optional). ID of the KMS Custom Key Store where the key will be stored instead of KMS (e.g., CloudHSM). | `string` | `null` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | (Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC\_DEFAULT, RSA\_2048, RSA\_3072, RSA\_4096, HMAC\_256, ECC\_NIST\_P256, ECC\_NIST\_P384, ECC\_NIST\_P521, or ECC\_SECG\_P256K1. Defaults to SYMMETRIC\_DEFAULT. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | (Optional). The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`. | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional). The description of the KMS key. | `string` | `"Custom KMS key."` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Specifies whether key rotation is enabled. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_enable_route53_dnssec"></a> [enable\_route53\_dnssec](#input\_enable\_route53\_dnssec) | (Optional). Determines whether the KMS policy used for Route53 DNSSEC signing is enabled. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional). Specifies whether the key is enabled. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | (Optional). Name of the current environment. | `string` | `"dev"` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | (Optional). A map of grant definitions to create. | `any` | `{}` | no |
| <a name="input_key_administrators"></a> [key\_administrators](#input\_key\_administrators) | (Optional). A list of IAM ARNs for [key administrators](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators). | `list(string)` | `[]` | no |
| <a name="input_key_asymmetric_public_encryption_users"></a> [key\_asymmetric\_public\_encryption\_users](#input\_key\_asymmetric\_public\_encryption\_users) | (Optional). A list of IAM ARNs for [key asymmetric public encryption users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto). | `list(string)` | `[]` | no |
| <a name="input_key_asymmetric_sign_verify_users"></a> [key\_asymmetric\_sign\_verify\_users](#input\_key\_asymmetric\_sign\_verify\_users) | (Optional). A list of IAM ARNs for [key asymmetric sign and verify users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto). | `list(string)` | `[]` | no |
| <a name="input_key_hmac_users"></a> [key\_hmac\_users](#input\_key\_hmac\_users) | (Optional). A list of IAM ARNs for [key HMAC users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto). | `list(string)` | `[]` | no |
| <a name="input_key_material_base64"></a> [key\_material\_base64](#input\_key\_material\_base64) | Base64 encoded 256-bit symmetric encryption key material to import. The CMK is permanently associated with this key material. External key only. | `string` | `null` | no |
| <a name="input_key_owners"></a> [key\_owners](#input\_key\_owners) | (Optional). A list of IAM ARNs for those who will have full key permissions (`kms:*`). | `list(string)` | `[]` | no |
| <a name="input_key_service_roles_for_autoscaling"></a> [key\_service\_roles\_for\_autoscaling](#input\_key\_service\_roles\_for\_autoscaling) | (Optional). A list of IAM ARNs for [AWSServiceRoleForAutoScaling roles](https://docs.aws.amazon.com/autoscaling/ec2/userguide/key-policy-requirements-EBS-encryption.html#policy-example-cmk-access). | `list(string)` | `[]` | no |
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | (Optional). A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration). | `list(string)` | `[]` | no |
| <a name="input_key_statements"></a> [key\_statements](#input\_key\_statements) | (Optional). A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage. | `any` | `{}` | no |
| <a name="input_key_symmetric_encryption_users"></a> [key\_symmetric\_encryption\_users](#input\_key\_symmetric\_encryption\_users) | (Optional). A list of IAM ARNs for [key symmetric encryption users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto). | `list(string)` | `[]` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | (Optional). Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT` or `SIGN_VERIFY`. Defaults to `ENCRYPT_DECRYPT`. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_key_users"></a> [key\_users](#input\_key\_users) | (Optional). A list of IAM ARNs for [key users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users). | `list(string)` | `[]` | no |
| <a name="input_multi_region"></a> [multi\_region](#input\_multi\_region) | (Optional). Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required). The name (e.g., alias) of the KMS key. | `string` | n/a | yes |
| <a name="input_override_policy_documents"></a> [override\_policy\_documents](#input\_override\_policy\_documents) | (Optional). List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`. | `list(string)` | `[]` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional). A valid policy JSON document. Although this is a key policy, not an IAM policy, an `aws_iam_policy_document`, in the form that designates a principal, can be used. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Optional). Prefix override for all generated naming conventions. | `string` | `"cs"` | no |
| <a name="input_primary_external_key_arn"></a> [primary\_external\_key\_arn](#input\_primary\_external\_key\_arn) | (Optional). The primary external key arn of a multi-region replica external key. | `string` | `null` | no |
| <a name="input_primary_key_arn"></a> [primary\_key\_arn](#input\_primary\_key\_arn) | (Optional). The primary key arn of a multi-region replica key. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | (Optional). Name of the client project. | `string` | `"pmod"` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional). Name of the region. | `string` | `"us-west-1"` | no |
| <a name="input_rotation_period_in_days"></a> [rotation\_period\_in\_days](#input\_rotation\_period\_in\_days) | (Optional). Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive) | `number` | `365` | no |
| <a name="input_route53_dnssec_sources"></a> [route53\_dnssec\_sources](#input\_route53\_dnssec\_sources) | (Optional). A list of maps containing `account_ids` and Route53 `hosted_zone_arn` that will be allowed to sign DNSSEC records. | `list(any)` | `[]` | no |
| <a name="input_source_policy_documents"></a> [source\_policy\_documents](#input\_source\_policy\_documents) | (Optional). List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional). A map of tags to assign to the resources. | `map(string)` | `null` | no |
| <a name="input_valid_to"></a> [valid\_to](#input\_valid\_to) | (Optional). Time at which the imported key material expires. When the key material expires, AWS KMS deletes the key material and the CMK becomes unusable. If not specified, key material does not expire. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aliases"></a> [aliases](#output\_aliases) | A map of aliases created and their attributes |
| <a name="output_external_key_expiration_model"></a> [external\_key\_expiration\_model](#output\_external\_key\_expiration\_model) | Whether the key material expires. Empty when pending key material import, otherwise `KEY_MATERIAL_EXPIRES` or `KEY_MATERIAL_DOES_NOT_EXPIRE` |
| <a name="output_external_key_state"></a> [external\_key\_state](#output\_external\_key\_state) | The state of the CMK |
| <a name="output_external_key_usage"></a> [external\_key\_usage](#output\_external\_key\_usage) | The cryptographic operations for which you can use the CMK |
| <a name="output_grants"></a> [grants](#output\_grants) | A map of grants created and their attributes |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | The Amazon Resource Name (ARN) of the key |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | The globally unique identifier for the key |
| <a name="output_key_policy"></a> [key\_policy](#output\_key\_policy) | The IAM resource policy set on the key |
<!-- END_TF_DOCS -->