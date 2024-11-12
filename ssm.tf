module "ssm" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-ssm-parameter.git?ref=b7659e8b46aa626065c60fbfa7b78c1fedf43d7c"

  name  = coalesce(var.ssm_parameter_name, "/kms/${var.env}/${local.name}")
  value = module.kms.key_id

  tags = local.tags
}
