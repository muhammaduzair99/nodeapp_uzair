resource "aws_instance" "metabase_instance" {
  ami                         = "ami-0aeeeef9c37751b0b" # Amazon Linux 2
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              docker run -d -p 3001:3000 --name metabase metabase/metabase
              EOF

  tags = {
    Name = "metabase-instance"
  }
}
