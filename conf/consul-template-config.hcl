consul {
  address = "192.168.10.11:8500"

  retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}
template {
  source      = "/etc/nginx/sites-available/load-balancer.conf.ctmpl"
  destination = "/etc/nginx/sites-available/default"
  perms       = 0600
  command     = "service nginx reload"
}
