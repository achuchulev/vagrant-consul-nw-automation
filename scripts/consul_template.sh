#!/usr/bin/env bash

set -x

which wget unzip &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --no-install-recommends -y wget unzip
}

CONSUL_TEMPLATE=$(curl -sL https://releases.hashicorp.com/consul-template/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

which consul-template &>/dev/null || {
  echo Installing vault ${CONSUL_TEMPLATE}
  wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE}/consul-template_${CONSUL_TEMPLATE}_linux_amd64.zip
  unzip consul-template_${CONSUL_TEMPLATE}_linux_amd64.zip
  mv consul-template /usr/local/bin
  mkdir --parents /etc/consul-template.d
  chown consul:consul /etc/consul-template.d
  cp /vagrant/conf/consul-template-config.hcl /etc/consul-template.d/consul-template-config.hcl
  # Configure nginx lb
  # Stop nginx service
  systemctl stop nginx.service
  # Remove default conf of nginx
  [ -f /etc/nginx/sites-available/default ] && {
   rm -fr /etc/nginx/sites-available/default
  }
  # Create a template file for consul-template
  cat <<EOF > /etc/nginx/sites-available/load-balancer.conf.ctmpl
upstream backend {
{{ range service "web" }}
  server {{ .Address }}:{{ .Port }};
{{ end }}
}

server {
   listen 80;

   location / {
      proxy_pass http://backend;
   }
}
EOF
  # Start nginx service
  systemctl start nginx.service
  # Run consul-template in background
  consul-template -config "/etc/consul-template.d/consul-template-config.hcl" &
}
