#!/usr/bin/env bash

set -x

cp /vagrant/conf/web-service.hcl /etc/consul.d/web-service.hcl
consul reload
