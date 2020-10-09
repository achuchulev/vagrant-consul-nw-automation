#!/usr/bin/env bash

set -x

# Remove default index page of nginx
[ -f /var/www/html/index.nginx-debian.html ] && {
 rm -fr /var/www/html/index.nginx-debian.html
}  

consul catalog nodes -service=web | grep $(hostname) > /var/www/html/index.nginx-debian.html

service nginx reload
