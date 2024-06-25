resource "aws_kms_key" "this" {
  count                    = (var.deletion_prevention == true) ? 0 : 1
  description              = var.description
  is_enabled               = var.enabled
  multi_region             = var.multi_region
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  rotation_period_in_days  = var.rotation_period_in_days
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  xks_key_id               = var.xks_key_id
  custom_key_store_id      = var.custom_key_store_id

  # Note: All KMS keys must have a key policy. If a key policy is not specified,
  # AWS gives the KMS key a default key policy that gives all principals in the owning account 
  # unlimited access to all KMS operations for the key. This default key policy effectively delegates
  # all access control to IAM policies and KMS grants.
  policy = var.policy

  # CAUTION: Set to false for most cases.
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check

  tags = var.tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_alias" "this" {
  count         = (var.deletion_prevention == true) ? 0 : 1
  name          = coalesce(var.alias, format("alias/%v", local.name))
  target_key_id = join("", aws_kms_key.this[0].*.id)

  lifecycle {
    prevent_destroy = false
  }
}

#
# Keys that should not be deleted on terraform destroy.
#
resource "aws_kms_key" "this_no_delete" {
  count                    = (var.deletion_prevention == true) ? 1 : 0
  description              = var.description
  is_enabled               = var.enabled
  multi_region             = var.multi_region
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  rotation_period_in_days  = var.rotation_period_in_days
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  xks_key_id               = var.xks_key_id
  custom_key_store_id      = var.custom_key_store_id

  # Note: All KMS keys must have a key policy. If a key policy is not specified,
  # AWS gives the KMS key a default key policy that gives all principals in the owning account 
  # unlimited access to all KMS operations for the key. This default key policy effectively delegates
  # all access control to IAM policies and KMS grants.
  policy = var.policy

  # CAUTION: Set to false for most cases.
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check

  tags = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "this_no_delete" {
  count         = (var.deletion_prevention == true) ? 1 : 0
  name          = coalesce(var.alias, format("alias/%v", local.name))
  target_key_id = join("", aws_kms_key.this_no_delete[0].*.id)

  lifecycle {
    prevent_destroy = true
  }
}