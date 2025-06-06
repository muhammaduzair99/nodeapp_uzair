#!/bin/bash
sudo su

# Update system and install dependencies
yum update -y
yum install -y git curl nginx docker

# Start and enable services
systemctl start docker
systemctl enable docker
amazon-linux-extras install nginx1 -y
systemctl start nginxa
systemctl enable nginx

# Set up app directory and copy files from docker folder
mkdir -p /home/ec2-user/app
cp -r /home/ec2-user/docker/* /home/ec2-user/app/
cd /home/ec2-user/app

# Build Docker image and run container
docker build -t nodeapp .
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
