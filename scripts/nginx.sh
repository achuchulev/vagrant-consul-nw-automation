#!/usr/bin/env bash

set -x

which curl wget unzip jq dig nginx &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --no-install-recommends -y curl wget unzip jq dnsutils nginx
}
