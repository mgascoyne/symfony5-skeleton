# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile for running Docker inside Virtualbox
Vagrant.configure("2") do |config|
    config.env.enable
    config.vm.define "symfony5-skeleton" do |config|
        config.vm.box = "ubuntu/bionic64"

        config.vm.network :private_network, ip: ENV['IPADDR']
        config.vm.hostname = ENV['HOST']
        config.vm.network :forwarded_port, guest: 80, host: 80, host_ip: ENV['IPADDR']
        config.vm.network :forwarded_port, guest: 3306, host: 3306, host_ip: ENV['IPADDR']
        config.vm.network :forwarded_port, guest: 8080, host: 8080, host_ip: ENV['IPADDR']
        config.vm.network :forwarded_port, guest: 8081, host: 8081, host_ip: ENV['IPADDR']
        config.vm.network :forwarded_port, guest: 8082, host: 8082, host_ip: ENV['IPADDR']
        config.vm.network :forwarded_port, guest: 8083, host: 8083, host_ip: ENV['IPADDR']
        config.vm.network :forwarded_port, guest: 8084, host: 8084, host_ip: ENV['IPADDR']

        config.vm.synced_folder ".", "/app", type: "nfs", rsync__auto: true
        config.ssh.forward_agent = true

        config.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", ENV['VIRTUALBOX_MEMORY']]
            vb.customize ["modifyvm", :id, "--cpus", ENV['VIRTUALBOX_CPUS']]
            vb.customize ["modifyvm", :id, "--paravirtprovider", ENV['VIRTUALBOX_PROVIDER']]
        end

        # Provisioning
        config.vm.provision :shell, :keep_color => true, :path => "./vagrant-provisioning.sh"

        # Start Docker stack
        config.vm.provision :shell, :keep_color => true, :path => "./vagrant-docker-start.sh", run: 'always'
    end
end
