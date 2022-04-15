resource "aws_security_group" "allowed_ports" {
  name        = "allowed ports"
  description = "ports that needed for work"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  #depends_on = [aws_vpc.tf_vpc]
}
