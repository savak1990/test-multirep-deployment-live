output "all_arn" {
  value       = values(aws_iam_user.example)[*].arn
  description = "The ARN of the first user"
}

output "upper_names" {
  value       = [for name in var.user_names : upper(name) if length(name) < 5]
  description = "User Names in uppercase"
}

output "bios" {
  value = { for name, role in var.hero_thousand_faces : upper(name) => upper(role) }
}

output "for_directive" {
  value = "%{for index, name in var.user_names}${index}: ${name}, %{endfor}"
}
