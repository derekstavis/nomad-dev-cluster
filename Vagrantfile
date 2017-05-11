# -*- mode: ruby -*-
# vi: set ft=ruby :


$script = <<SCRIPT
# Everything is there
cd /tmp/

# Install some stuff and upgrade the system
rm -rf /var/lib/pacman/db.lck
pacman -Syu --needed --force --noconfirm unzip curl wget vim docker

# Download Nomad
NOMAD_VERSION=0.5.6
echo Fetching Nomad...
rm -rf nomad.zip
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip

echo Installing Nomad...
unzip nomad.zip
mv -f nomad /usr/bin/
chmod +x /usr/bin/nomad

# Setup configuration
mkdir -p /etc/nomad.d
chmod a+w /etc/nomad.d
ipaddr=$(ip -o route get 10.0.50.0/24 | awk '{print $7;exit}')
hostname=$(hostname)
sed -i -e s/IPADDR/$ipaddr/ server.hcl
mv -f server.hcl /etc/nomad.d/
mv -f nomad.service /usr/lib/systemd/system/

# Disable IPv6 networking
echo "net.ipv6.conf.all.disable_ipv6 = 1" > /etc/sysctl.d/10-no-ipv6.conf
sysctl --system

# Enable services
systemctl enable docker
systemctl enable nomad

SCRIPT


Vagrant.configure(2) do |config|
  (1..3).each do |i|
    config.vm.define "nomad-node-#{i}" do |node|
      node.vm.box      = "wholebits/archlinux"
      node.vm.hostname = "nomad-node-#{i}"

      node.vm.network "private_network", ip: "10.0.50.1#{i}"

      node.vm.provision :hosts, sync_hosts: true, add_localhost_hostnames: false

      node.vm.provision :file, source: "server.hcl", destination: "/tmp/server.hcl"
      node.vm.provision :file, source: "nomad.service", destination: "/tmp/nomad.service"

      node.vm.provision :shell, inline: $script, privileged: true

      node.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
    end
  end
end
