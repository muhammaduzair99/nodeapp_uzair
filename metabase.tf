resource "aws_instance" "metabase_instance" {
  ami                         = "ami-0d1b5a8c13042c939" # Ubuntu Server 24.04 LTS
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y && apt upgrade -y
              apt install -y docker.io docker-compose nginx curl python3-certbot-nginx

              fallocate -l 1G /swapfile
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile none swap sw 0 0' >> /etc/fstab

              systemctl enable docker --now
              systemctl enable nginx --now
              usermod -aG docker ubuntu
              sleep 10

              mkdir -p /home/ubuntu/metabase
              cd /home/ubuntu/metabase

              cat <<EOT > docker-compose.yml
              version: '3'
              services:
                metabase:
                  image: metabase/metabase:latest
                  container_name: metabase
                  ports:
                    - "3001:3000"
                  volumes:
                    - metabase-data:/metabase-data
                  environment:
                    MB_DB_FILE: /metabase-data/metabase.db
                  restart: always
              volumes:
                metabase-data:
              EOT

              chown -R ubuntu:ubuntu /home/ubuntu/metabase
              cd /home/ubuntu/metabase
              sudo -u ubuntu docker-compose up -d

              cat <<EOT > /etc/nginx/sites-available/metabase
              server {
                  listen 80;
                  server_name bi.codelessops.site;

                  location / {
                      proxy_pass http://localhost:3001/;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }
              EOT

              ln -sf /etc/nginx/sites-available/metabase /etc/nginx/sites-enabled/metabase
              rm -f /etc/nginx/sites-enabled/default
              nginx -t && systemctl restart nginx

              sleep 120
              certbot --nginx -d bi.codelessops.site --non-interactive --agree-tos -m m.uzairsajjad@gmail.com || echo "Certbot failed — run it manually later"
              certbot renew --dry-run
              EOF

  tags = {
    Name = "metabase-instance"
  }
}
