module "ssm" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  version = "~> 1.1.1"

  name  = coalesce(var.ssm_parameter_name, "/kms/${var.env}/${local.name}")
  value = module.kms.key_id

  tags = var.tags
}