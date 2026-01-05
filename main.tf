data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

locals {
    ami = var.ami == null ? data.aws_ami.linux.id : var.ami
}

resource "aws_instance" "this" {
  ami                     = local.ami
  instance_type           = var.instance_type
  iam_instance_profile    = try(aws_iam_instance_profile.ssm_profile[0].name, var.instance_profile, null)
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.sg

  tags = {
    Name = var.name
  }
}

resource "aws_iam_role" "ssm_role" {
  count = var.ssm_managed && var.instance_profile == null ? 1 : 0
  name  = "ssm_role"
  
  
  assume_role_policy = jsonencode({
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "ssm_role_attach" {
  count      = var.ssm_managed && var.instance_profile == null ? 1 : 0
  role       = aws_iam_role.ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  count = var.ssm_managed && var.instance_profile == null ? 1 : 0
  name  = "ssm_profile"
  role  = aws_iam_role.ssm_role[0].name
}