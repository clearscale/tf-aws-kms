module "ssm" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  version = "~> 1.1.1"

  name  = local.ssm_parameter_name
  value = module.kms.key_id

  tags = var.tags
}