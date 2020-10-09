#!/usr/bin/env bash

set -x

cp /vagrant/service_config/web-service.hcl /etc/consul.d/web-service.hcl
consul reload
