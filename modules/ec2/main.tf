data "aws_ami" "ubuntu_latest" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "public_instance" {
  count                  = var.amount
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = "t2.micro"
  key_name               = "aws-main"
  vpc_security_group_ids = [var.security_group_id]
  user_data              = file("./modules/ec2/user_data.sh")
  subnet_id              = var.public_subnets_ids[count.index]
  tags = {
    Name = "Public instance ${count.index + 1}"
  }
}

resource "aws_instance" "private_instance" {
  count                  = var.amount
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = "t2.micro"
  key_name               = "aws-main"
  vpc_security_group_ids = [var.security_group_id]
  user_data              = file("./modules/ec2/user_data.sh")
  subnet_id              = var.private_subnets_ids[count.index]
  tags = {
    Name = "Private instance ${count.index + 1}"
  }
}
