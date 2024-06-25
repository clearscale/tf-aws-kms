locals {
  name          = module.std.names.aws[var.account.name].general
  name_iam      = module.std.names.aws[var.account.name].title
  arn_partition = (var.arn_partition == null ? data.aws_partition.this.partition : var.arn_partition)

  policy   = ((var.policy != null) ? jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:${local.arn_partition}:iam::${data.aws_caller_identity.this.account_id}:root"
        },
        Action = "kms:*",
        Resource = "*"
      }
    ]
  }) : var.policy)
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

variable "alias" {
  type        = string
  description = "(Optional). The alias is generated automatically based on the standard parameters including `var.name`. This value allows the alias to be overridden."
  default     = null
}

#
# Example:
# "arn:(aws|aws-us-gov):iam::123456789012:root"
#
variable "arn_partition" {
  type        = string
  description = "(Optional). Override the partition to specify in the ARN (aws or aws-us-gov)."
  default     = null
}

variable "description" {
  type        = string
  description = "(Optional). The description of the KMS key."
  default     = "Custom KMS key."
}

variable "enabled" {
  description = "(Optional). Specifies whether the key is enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "(Optional). Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_key_rotation" {
  description = "(Optional). Enable key rotation?"
  type        = bool
  default     = true
}

variable "rotation_period_in_days" {
  description = " (Optional). Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive). The key should be rotated at least once per year at a minimum."
  type        = number
  default     = 365
}

variable "key_spec" {
  description = "(Optional). Key spec for the KMS key."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "xks_key_id" {
  description = "(Optional). Identifies the external key that serves as key material for the KMS key in an external key store."
  type        = string
  default     = null
}

# https://docs.aws.amazon.com/kms/latest/developerguide/create-cmk-keystore.html
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

variable "key_usage" {
  description = "(Optional). Key usage for the KMS key."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "deletion_window_in_days" {
  description = "(Optional). Deletion window in days for key deletion."
  type        = number
  default     = 30
}

variable "policy" {
  description = "The IAM policy for the KMS key. An over permissive policy is used as a default. It's best practice to set this."
  type        = string
  default     = null
}

variable "bypass_policy_lockout_safety_check" {
  description = " (Optional). A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable. Do not set this value to true indiscriminately. For more information, refer to the scenario in the Default Key Policy section in the AWS Key Management Service Developer Guide. The default value is false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional). A map of tags to assign to the resources."
  type        = map(string)
  default     = null
}