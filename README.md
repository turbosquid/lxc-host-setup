lxc-host-setup
==============
Sets up or updates an lxc-host
First run is slow -- updates are fast
The base distribution should be Ubuntu 13.04 (x64). If using a VM you should probably intall the VM tools
To run: 

    wget -qO- https://raw.github.com/turbosquid/lxc-host-setup/master/host-setup.sh | bash
    # Under Ubuntu 14.04 you may need to use curl
    curl -Lo- https://raw.github.com/turbosquid/lxc-host-setup/master/host-setup.sh | bash

