#!/bin/bash

sudo su
# Update system and install dependencies
yum update -y
yum install -y git curl nginx docker

# Start and enable services
systemctl start docker
systemctl enable docker
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx

# Clone app repo
# git clone https://github.com/muhammaduzair99/nodeapp_uzair.git /home/ec2-user/app
# chown -R ec2-user:ec2-user /home/ec2-user/app
# cd /home/ec2-user/app/docker
docker pull uzair99/nodeapp-project:0.0.1

# # Build and run Docker container
# docker build -t nodeapp .
docker run -d -p 3000:3000 --name nodeapp uzair99/nodeapp-project:0.0.2

# Configure NGINX reverse proxy
cat <<EOF > /etc/nginx/conf.d/nodeapp.conf
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Reload NGINX
nginx -t && systemctl reload nginx
