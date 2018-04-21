# NixOS Configs
My NixOS configurations for desktop systems

## Quick Start
To use this project, you will need

 * git
 * A running NixOS system
 
To use these configs, clone the project and update

    cd /etc/nixos
    
    # Clone out the repository
    git init
    git fetch git@github.com:sgillespie/nixos-configs.git
    git reset --hard origin/master
    git clean -fd
    
    # Build the system
    nixos-rebuild switch
    
Then reboot and everything should be set up

# Author
**Sean Gillespie** [sean@mistersg.net](mailto:sean@mistersg.net)

# License
This project is licensed under the MIT License. See [LICENSE](LICENSE)
