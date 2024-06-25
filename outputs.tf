output "key_arn" {
  value       = join("", (var.deletion_prevention == false) ? aws_kms_key.this.*.arn : aws_kms_key.this_no_delete.*.arn)
  description = "Key ARN"
}

output "key_id" {
  value       = join("", (var.deletion_prevention == false) ? aws_kms_key.this.*.key_id : aws_kms_key.this_no_delete.*.key_id)
  description = "Key ID"
}

output "alias_arn" {
  value       = join("", (var.deletion_prevention == false) ? aws_kms_alias.this.*.arn : aws_kms_alias.this_no_delete.*.arn)
  description = "Alias ARN"
}

output "alias_name" {
  value       = join("", (var.deletion_prevention == false) ? aws_kms_alias.this.*.name : aws_kms_alias.this_no_delete.*.name)
  description = "Alias name"
}

