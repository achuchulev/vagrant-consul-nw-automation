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
}
