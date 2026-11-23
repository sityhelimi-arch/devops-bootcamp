terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_key_pair" "deployer" {
  key_name   = "ansible-deployer-grafana-key"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

resource "aws_instance" "node1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.node_firewall.id]
  associate_public_ip_address = true

  tags = {
    Name = "node1"
  }
}

resource "aws_instance" "node2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.node_firewall.id]
  associate_public_ip_address = true

  tags = {
    Name = "node2"
  }
}

resource "local_file" "inventory" {
  filename = "inventory.ini"
  content  = <<EOT
[nodes]
node1 ansible_host=${aws_instance.node1.public_ip}
node2 ansible_host=${aws_instance.node2.public_ip}

[nodes:vars]
ansible_user=ubuntu
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=/home/sity/.ssh/id_ed25519
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ServerAliveInterval=30'
EOT
}

output "node1_public_ip" {
  value = aws_instance.node1.public_ip
}

output "node2_public_ip" {
  value = aws_instance.node2.public_ip
}
