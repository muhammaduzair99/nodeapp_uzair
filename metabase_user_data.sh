# #!/bin/bash

# # Update and install core services
# yum update -y
# amazon-linux-extras enable nginx1 -y
# yum install -y nginx docker python2-certbot-nginx

# # Enable and start services
# systemctl start nginx
# systemctl enable nginx
# systemctl start docker
# systemctl enable docker

# # Run Metabase container
# docker run -d -p 3001:3000 --name metabase metabase/metabase

# # Create NGINX reverse proxy for Metabase
# cat <<EOF > /etc/nginx/conf.d/metabase.conf
# server {
#     listen 80;
#     server_name bi.codelessops.site;

#     location / {
#         proxy_pass http://localhost:3001;
#         proxy_http_version 1.1;
#         proxy_set_header Upgrade \$http_upgrade;
#         proxy_set_header Connection 'upgrade';
#         proxy_set_header Host \$host;
#         proxy_cache_bypass \$http_upgrade;
#     }
# }
# EOF

# # Reload NGINX config
# nginx -t && systemctl reload nginx

# # Wait to ensure DNS has propagated
# sleep 60

# # Issue SSL Certificate
# certbot --nginx -d bi.codelessops.site --agree-tos --no-eff-email -m m.uzairsajjad@gmail.com --non-interactive
