locals {
  # tflint-ignore: terraform_unused_declarations
  prefix = coalesce(var.prefix, "cs")
  # tflint-ignore: terraform_unused_declarations
  client = coalesce(var.client, "ClearScale")
  # tflint-ignore: terraform_unused_declarations
  project = coalesce(var.project, "pmod")
  # tflint-ignore: terraform_unused_declarations
  account = coalesce(var.account, { id = data.aws_caller_identity.this.account_id, name = "shared" })
  # tflint-ignore: terraform_unused_declarations
  env = coalesce(var.env, "dev")
  # tflint-ignore: terraform_unused_declarations
  region = coalesce(var.region, "us-west-1")
  # tflint-ignore: terraform_unused_declarations
  name = module.std.names.aws[var.account.name].general
  # tflint-ignore: terraform_unused_declarations
  name_std = var.name
  # tflint-ignore: terraform_unused_declarations
  description = coalesce(var.description, "Custom KMS key.")


  # Ensure the required tags are included
  mandatory_tags = {}

  # Merge user-provided tags with mandatory tags
  # tflint-ignore: terraform_unused_declarations
  tags = merge(var.tags, local.mandatory_tags)
}