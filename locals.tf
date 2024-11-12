locals {
  name = module.std.names.aws[var.account.name].general

  # Ensure the required tags are included
  mandatory_tags = {}

  # Merge user-provided tags with mandatory tags
  # tflint-ignore: terraform_unused_declarations
  tags = merge(var.tags, local.mandatory_tags)
}