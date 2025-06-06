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

# Clone your app from GitHub
cd /home/ec2-user
git clone https://github.com/muhammaduzair99/nodeapp_uzair.git app
cd app

# Build Docker image and run container
docker build -t nodeapp ./docker
docker run -d -p 3000:3000 --name nodeapp nodeapp

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

# Apply NGINX config
nginx -t && systemctl reload nginx

# Set permissions
chown -R ec2-user:ec2-user /home/ec2-user/app
