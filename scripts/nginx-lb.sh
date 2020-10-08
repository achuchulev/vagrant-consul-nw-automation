#!/usr/bin/env bash

set -x

# Configure nginx lb
echo "Configuring nginx load balancer...."

# Stop nginx service
systemctl stop nginx.service

# Remove default conf of nginx
[ -f /etc/nginx/sites-available/default ] && {
 rm -fr /etc/nginx/sites-available/default
}

# Copy our nginx conf
cat <<EOF > /etc/nginx/sites-available/load-balancer.conf.ctmpl
upstream backend {
{{ range service "web" }}
  server {{ .Address }}:{{ .Port }};
{{ end }}
}

server {
   listen 8080;

   location / {
      proxy_pass http://backend;
   }
}
EOF

# Start nginx service
systemctl start nginx.service
