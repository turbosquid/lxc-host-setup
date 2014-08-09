lxc-host-setup
==============
Sets up or updates an lxc-host
First run is slow -- updates are fast
The base distribution should be Ubuntu 13.04 or 14.04 (x64). If using a VM you should probably intall the VM tools
To run: 

    curl -Lo- https://raw.github.com/turbosquid/lxc-host-setup/master/host-setup.sh | bash # On 13.04
    
On Ubuntu 14.04 you will need to download the script first, and then run it -- something about later versions of apt-get seem to break piping a script directly into bash

