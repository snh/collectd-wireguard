# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "256"
  end

  (1..2).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "10.74.241.1#{i}"
      node.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get upgrade
        apt-get install --yes git libmnl-dev libelf-dev linux-headers-$(uname -r) build-essential pkg-config collectd-core

        git clone https://git.zx2c4.com/WireGuard
        cd WireGuard/src
        make
        make install
        cd ~

        cp /vagrant/vagrant/node-#{i}/wg0.conf /etc/wireguard/wg0.conf
        wg-quick up wg0

        cp /vagrant/vagrant/collectd.conf /etc/collectd/collectd.conf
        cp /vagrant/collectd-wireguard.sh /usr/share/collectd/collectd-wireguard.sh
        chmod +x /usr/share/collectd/collectd-wireguard.sh
        systemctl restart collectd
      SHELL
    end
  end
end

