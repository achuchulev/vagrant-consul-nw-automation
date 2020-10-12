#!/usr/bin/env bash

set -x

# Remove default index page of nginx
[ -f /var/www/html/index.nginx-debian.html ] && {
 rm -fr /var/www/html/index.nginx-debian.html
}

echo $(hostname) > /var/www/html/index.nginx-debian.html
