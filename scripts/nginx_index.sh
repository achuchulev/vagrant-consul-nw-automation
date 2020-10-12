#!/usr/bin/env bash

set -x

# Remove default index page of nginx
[ -f /var/www/html/index.nginx-debian.html ] && {
 rm -fr /var/www/html/index.nginx-debian.html
}  

if [ $(consul catalog nodes -service=web | wc -l) -eq 0 ]; then
    sleep 10
    consul catalog nodes -service=web | grep $(hostname) > /var/www/html/index.nginx-debian.html
else
    consul catalog nodes -service=web | grep $(hostname) > /var/www/html/index.nginx-debian.html
fi
