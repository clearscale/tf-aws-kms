locals {
  name = module.std.names.aws[var.account.name].general
}

variable "prefix" {
  type        = string
  description = "(Optional). Prefix override for all generated naming conventions."
  default     = "cs"
}

variable "client" {
  type        = string
  description = "(Optional). Name of the client"
  default     = "ClearScale"
}

variable "project" {
  type        = string
  description = "(Optional). Name of the client project."
  default     = "pmod"
}

variable "account" {
  description = "(Optional). Current cloud provider account info."
  type = object({
    key      = optional(string, "current")
    provider = optional(string, "aws")
    id       = optional(string, "*")
    name     = string
    region   = optional(string, null)
  })
  default = {
    id   = "*"
    name = "shared"
  }
}

variable "env" {
  type        = string
  description = "(Optional). Name of the current environment."
  default     = "dev"
}

variable "region" {
  type        = string
  description = "(Optional). Name of the region."
  default     = "us-west-1"
}

variable "name" {
  type        = string
  description = "(Required). The name (e.g., alias) of the KMS key."
}

variable "description" {
  type        = string
  description = "(Optional). The description of the KMS key."
  default     = "Custom KMS key."
}

variable "enabled" {
  description = "(Optional). Specifies whether the key is enabled. Defaults to `true`."
  type        = bool
  default     = true
}

variable "aliases" {
  description = "(Optional). A list of aliases to create. Note - due to the use of `toset()`, values must be static strings and not computed values."
  type        = list(string)
  default     = []
}

variable "computed_aliases" {
  description = "(Optional). A map of aliases to create. Values provided via the `name` key of the map can be computed from upstream resources."
  type        = any
  default     = {}
}

variable "aliases_use_name_prefix" {
  description = "(Optional). Determines whether the alias name is used as a prefix."
  type        = bool
  default     = false
}

variable "multi_region" {
  description = "(Optional). Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to `true`."
  type        = bool
  default     = true
}

variable "rotation_period_in_days" {
  description = "(Optional). Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive)"
  type        = number
  default     = 365
}

variable "deletion_window_in_days" {
  description = "(Optional). The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`."
  type        = number
  default     = 30
}

variable "create_external" {
  description = "(Optional). Determines whether an external CMK (externally provided material) will be created or a standard CMK (AWS provided material)."
  type        = bool
  default     = false
}

variable "bypass_policy_lockout_safety_check" {
  description = "(Optional). A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable."
  type        = bool
  default     = false
}

variable "custom_key_store_id" {
  description = "(Optional). ID of the KMS Custom Key Store where the key will be stored instead of KMS (e.g., CloudHSM)."
  type        = string
  default     = null
}

# https://docs.aws.amazon.com/kms/latest/developerguide/overview.html
variable "customer_master_key_spec" {
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, HMAC_256, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "key_material_base64" {
  description = "Base64 encoded 256-bit symmetric encryption key material to import. The CMK is permanently associated with this key material. External key only."
  type        = string
  default     = null
}

variable "key_usage" {
  description = "(Optional). Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT` or `SIGN_VERIFY`. Defaults to `ENCRYPT_DECRYPT`."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

# Check the default policy before applying a custom policy:
# https://github.com/terraform-aws-modules/terraform-aws-kms/blob/fe1beca2118c0cb528526e022a53381535bb93cd/main.tf#L95
variable "policy" {
  description = "(Optional). A valid policy JSON document. Although this is a key policy, not an IAM policy, an `aws_iam_policy_document`, in the form that designates a principal, can be used."
  type        = string
  default     = null
}

variable "valid_to" {
  description = "(Optional). Time at which the imported key material expires. When the key material expires, AWS KMS deletes the key material and the CMK becomes unusable. If not specified, key material does not expire."
  type        = string
  default     = null
}

variable "key_owners" {
  description = "(Optional). A list of IAM ARNs for those who will have full key permissions (`kms:*`)."
  type        = list(string)
  default     = []
}

variable "key_administrators" {
  description = "(Optional). A list of IAM ARNs for [key administrators](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators)."
  type        = list(string)
  default     = []
}

variable "key_users" {
  description = "(Optional). A list of IAM ARNs for [key users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users)."
  type        = list(string)
  default     = []
}

variable "key_service_users" {
  description = "(Optional). A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration)."
  type        = list(string)
  default     = []
}

variable "key_service_roles_for_autoscaling" {
  description = "(Optional). A list of IAM ARNs for [AWSServiceRoleForAutoScaling roles](https://docs.aws.amazon.com/autoscaling/ec2/userguide/key-policy-requirements-EBS-encryption.html#policy-example-cmk-access)."
  type        = list(string)
  default     = []
}

variable "key_symmetric_encryption_users" {
  description = "(Optional). A list of IAM ARNs for [key symmetric encryption users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto)."
  type        = list(string)
  default     = []
}

variable "key_hmac_users" {
  description = "(Optional). A list of IAM ARNs for [key HMAC users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto)."
  type        = list(string)
  default     = []
}

variable "key_asymmetric_public_encryption_users" {
  description = "(Optional). A list of IAM ARNs for [key asymmetric public encryption users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto)."
  type        = list(string)
  default     = []
}

variable "key_asymmetric_sign_verify_users" {
  description = "(Optional). A list of IAM ARNs for [key asymmetric sign and verify users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto)."
  type        = list(string)
  default     = []
}

variable "key_statements" {
  description = "(Optional). A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage."
  type        = any
  default     = {}
}

variable "source_policy_documents" {
  description = "(Optional). List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s."
  type        = list(string)
  default     = []
}

variable "override_policy_documents" {
  description = "(Optional). List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`."
  type        = list(string)
  default     = []
}

variable "enable_route53_dnssec" {
  description = "(Optional). Determines whether the KMS policy used for Route53 DNSSEC signing is enabled."
  type        = bool
  default     = false
}

variable "route53_dnssec_sources" {
  description = "(Optional). A list of maps containing `account_ids` and Route53 `hosted_zone_arn` that will be allowed to sign DNSSEC records."
  type        = list(any)
  default     = []
}

variable "create_replica" {
  description = "(Optional). Determines whether a replica standard CMK will be created (AWS provided material)."
  type        = bool
  default     = false
}

variable "primary_key_arn" {
  description = "(Optional). The primary key arn of a multi-region replica key."
  type        = string
  default     = null
}

variable "create_replica_external" {
  description = "(Optional). Determines whether a replica external CMK will be created (externally provided material)."
  type        = bool
  default     = false
}

variable "primary_external_key_arn" {
  description = "(Optional). The primary external key arn of a multi-region replica external key."
  type        = string
  default     = null
}

variable "grants" {
  description = "(Optional). A map of grant definitions to create."
  type        = any
  default     = {}
}

variable "ssm_parameter_name" {
  type        = string
  description = "(Required). SSM parameter name to store KMS key ID."
  default     = null
}

variable "tags" {
  description = "(Optional). A map of tags to assign to the resources."
  type        = map(string)
  default     = null
}
