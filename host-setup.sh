#!/usr/bin/env bash
#
# Sets up or updates an lxc-host
# First run is slow -- updates are fast
# The base distribution should be Ubuntu 13.04 (x64). If using a VM you should probably intall the VM tools
# To run: wget -qO- https://raw.github.com/turbosquid/lxc-host-setup/master/host-setup.sh | bash
 
set -iex
 
# Update Ubuntu
sudo apt-get -y update # Be sure eveything is up to date
sudo apt-get -y dist-upgrade
 
sudo apt-get -y install git

sudo apt-get -y install nginx
sudo apt-get -y install build-essential
sudo /etc/init.d/nginx start
 
# Install Ruby and required gems
sudo apt-get -y install ruby1.9.3
sudo gem install puppet --no-ri --no-rdoc
sudo gem install librarian-puppet --no-ri --no-rdoc
sudo gem install puppet_pal --no-ri --no-rdoc
 
# Install lxc and vagrant-lxc
sudo apt-get -y install lxc cgroup-lite redir # Install LXC and some additional useful bits
 
# At this point, you will have lxc installed. You could begin creating lxc containers now, but being able to use vagrant makes things a lot nicer. So install vagrant and the vagrant lxc plugin:
# Pull down the latest .deb file and install it
VAGRANT_DEB=vagrant_1.3.3_x86_64.deb
wget -nc "http://files.vagrantup.com/packages/db8e7a9c79b23264da129f55cf8569167fc22415/$VAGRANT_DEB"
sudo dpkg --install $VAGRANT_DEB
# rm -f $VAGRANT_DEB
sudo -i vagrant plugin install vagrant-lxc
vagrant plugin install vagrant-lxc
 
# Now you have almost everything installed. One final step – you will want to add the following line to /etc/environment:
VAGRANT_ENV="VAGRANT_DEFAULT_PROVIDER=lxc"
grep -q "$VAGRANT_ENV" /etc/environment || sudo sh -c "echo '$VAGRANT_ENV' >> /etc/environment"
 
# Install TS lxc tools
sudo wget https://raw.github.com/turbosquid/lxc-amigo/master/lxc-amigo -NO /usr/local/bin/lxc-amigo
sudo chmod 755 /usr/local/bin/lxc-amigo
sudo wget https://raw.github.com/turbosquid/lxc-clone-vagrant/master/lxc-clone -NO /usr/local/bin/lxc-clone
sudo chmod 755 /usr/local/bin/lxc-clone

# Preserve agent-forwarding on sudo
AGENT_KEEP="Defaults env_keep +=\"SSH_AUTH_SOCK\""
sudo grep -q SSH_AUTH_SOCK /etc/sudoers || sudo sh -c "echo '$AGENT_KEEP' >> /etc/sudoers"

set +e
# Enable agent forwarding in root config AND user config
mkdir -p ~/.ssh
touch ~/.ssh/config
grep -q ForwardAgent ~/.ssh/config
if [ $? -ne 0 ]; then 
 echo "Host *" >> ~/.ssh/config
 echo "   ForwardAgent yes" >> ~/.ssh/config
fi;
sudo mkdir -p /root/.ssh
sudo touch /root/.ssh/config
sudo grep -q ForwardAgent /root/.ssh/config
if [ $? -ne 0 ]; then 
 sudo sh -c 'echo "Host *" >> /root/.ssh/config'
 sudo sh -c 'echo "   ForwardAgent yes" >> /root/.ssh/config'
fi; 

set +x
 
echo
echo
echo "=================================================================="
echo "Finished!"
echo "=================================================================="
echo
echo
echo "Reboot Parallels host or run the following before running vagrant:"
echo "export $VAGRANT_ENV"
echo
echo
