# -*- mode: ruby -*-
# vi: set ft=ruby :

CONSUL_SERVER_COUNT = 3
APP_SERVER_COUNT = 3

vagrant_assets = File.dirname(__FILE__) + "/"

Vagrant.configure("2") do |config|

  # Set memory & CPU for Virtualbox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
    vb.cpus = "1"
  end

  (1..(CONSUL_SERVER_COUNT)).each do |i|
       config.vm.define vm_name="consul-server#{i}" do |consul_server|
       consul_server.vm.box = "achuchulev/bionic64"
       consul_server.vm.hostname = vm_name
       consul_server.vm.network "forwarded_port", guest: 8500, host: 8500 if i == 1
       consul_server.vm.network "private_network", ip: "192.168.10.1#{i}", netmask:"255.255.255.0"
       consul_server.vm.provision "shell", path: "#{vagrant_assets}/scripts/consul_server.sh", privileged: true
    end
  end
   (1..(APP_SERVER_COUNT)).each do |i|
        config.vm.define vm_name="app-server#{i}" do |app_server|
        app_server.vm.box = "achuchulev/bionic64"
        app_server.vm.hostname = vm_name
        app_server.vm.network "public_network", ip: "192.168.11.1#{i}", netmask:"255.255.255.0"
        app_server.vm.provision "shell", path: "#{vagrant_assets}/scripts/nginx.sh", privileged: true
        app_server.vm.provision "shell", path: "#{vagrant_assets}/scripts/consul_client.sh", privileged: true
     end
   end
   config.vm.define vm_name="nginx-lb" do |nginx_lb|
     nginx_lb.vm.box = "achuchulev/bionic64"
     nginx_lb.vm.hostname = vm_name
     nginx_lb.vm.network "forwarded_port", guest: 8080, host: 8080
     nginx_lb.vm.network "private_network", ip: "192.168.10.10", netmask:"255.255.255.0"
     nginx_lb.vm.provision "shell", path: "#{vagrant_assets}/scripts/nginx.sh", privileged: true
     nginx_lb.vm.provision "shell", path: "#{vagrant_assets}/scripts/consul_client.sh", privileged: true
     nginx_lb.vm.provision "shell", path: "#{vagrant_assets}/scripts/consul-template.sh", privileged: true
   end
end
