provider "aws" {
  region = "ap-northeast-1"
}


data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = "t3.micro"
  
  tags = {
      Name = "example"
  }

  user_data = <<EOF
  #!/bin/bash
  sudo amazon-linux-extras install nginx1.12 -y
  systemctl start nginx.service
EOF
}

output "example_instance_id" {
  value = "aws_instance.example.id"
}
