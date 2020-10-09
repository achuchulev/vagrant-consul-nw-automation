# Automate NW Infra with Consul and Consul template 

### This repo represents one use case of HashiCorp's Consul for [Network Infrastructure Automation](https://www.consul.io/use-cases/network-infrastructure-automation) to automatically update an NGINX configuration file with the latest list of backend servers using Consul's service discovery. It is based on the following example described here: [Load Balancing with NGINX and Consul Template](https://learn.hashicorp.com/tutorials/consul/load-balancing-nginx) 

## High Level Overview

<img src="diagram/consul-nginx-template-arch.PNG" />

## Requirements:

- git
- vagrant
- virtualbox

## How to use

#### Get the repo

```
$ git clone https://github.com/achuchulev/vagrant-nginx-lb-consul-template.git
$ cd vagrant-nginx-lb-consul-template
```
#### Run

```
$ vagrant up
```

- `vagrant up` will create the following instances on virtualbox:
  -  3 new VMs running Consul agents in `server` mode for Consul cluster
  -  2 new VMs running Consul agents in `client` mode and `Nginx` for our web app
  -  1 VM running `Nginx` load balancer and a `consul-template`

#### Use
  - Access [Consul UI](http://192.168.10.11:8500/ui/) to verify that consul cluster is up and there are two `web` services registered 
  - Access [Nginx Load Balancer](http://192.168.10.10) to verify that it serves queries
  - Examine `nginx` configuration on Nginx LB VM
  
  ```
  $ vagrant ssh nginx-lb
  $ sudo cat /etc/nginx/sites-available/default
  upstream backend {
    server 192.168.10.21:80;
    server 192.168.10.22:80;
  }

  server {
    listen 80;

   location / {
      proxy_pass http://backend;
    }
  }
  ```

#### Test NW automation
 - login to app-server1 and stop nginx service
 
 ```
 $ vagrant ssh app-server1
 $ sudo service nginx stop
 ```
 
 - Access [Nginx Load Balancer](http://192.168.10.10) to verify that it continue to serve queries
 - Examine `nginx` configuration on Nginx LB VM
 
 ```
 $ vagrant ssh nginx-lb
 $ sudo cat /etc/nginx/sites-available/default
 upstream backend {
  server 192.168.10.22:80;
 }

 server {
   listen 80;

   location / {
       proxy_pass http://backend;
   }
 }
 ```
 
### Destroy

```
$ vagrant destroy -f
```
