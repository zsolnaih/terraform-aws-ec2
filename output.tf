output "instance" {
  value = aws_instance.this
}

output "instance_profile_name" {
  value = try(aws_iam_instance_profile.ssm_profile[0].name, var.instance_profile, null)
}