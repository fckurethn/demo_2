output "instance_ids" {
  value = aws_instance.private_instance[*].id
}

output "amount" {
  value = var.amount
}
