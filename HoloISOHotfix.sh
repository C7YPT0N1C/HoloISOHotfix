#!/bin/bash

# HOLOISO COMMANDS:
# steamos-update [check|now]
# holoiso-[enable|disable]-sessions
# holoiso-grub-update
# steamos-sessions-select [plasma|gamescope|plasma-x11-persistent]


read -r -p "Do you want to use the '-rel' repositories (1) or the '-3.3' repositories (2)?  (1/2)?" choice # Chooses whether to use -rel repos or -3.3 repos
if [ "$choice" = "1" ]; then
        echo "Selecting '-rel' repositories."
        sudo mv ./pacman/pacman-rel-stable.conf ./pacman.conf
elif [ "$choice" = "2" ]; then
        echo "Selecting '-3.3' repositories."
        sudo mv ./pacman/pacman-3.3-stable.conf ./pacman.conf
else
        echo "Invalid Answer."
        exit
fi



read -r -p "File '/etc/pacman.conf' will be overwritten. Continue (y/n)?" choice # Update pacman.conf to latest working repos
if [ "$choice" = "y" ]; then
        echo "Updating file '/etc/pacman.conf'"
        sudo mv ./pacman.conf /etc/pacman.conf
elif [ "$choice" = "n" ]; then
        echo "Skipping updating file '/etc/pacman.conf'"
else
        echo "Invalid Answer."
        exit
fi

sudo pacman -Syyu # Update repos and packages
sudo pacman -Syu mesa-amber # Install mesa-amber as mesa causes visual artifacts
sudo pacman -Syu polkit # Installs polkit
sudo pacman -Syyu # Reupdates repos and packages just in case, also to prep for potential steamos-update
sudo steamos-update check # Checks for SteamOS updates
sudo steamos-update now # Updates SteamOS is an update is found 
sudo holoiso-grub-update # Updates holoiso grub configuration just to be safe

# The file "/root/.steam/root/config/SteamAppData.vdf" for some reason is required to exist for gamescope to properly initialise, however, it seems that this file is by default not created.
# The following section will check to see if it exists, and if it doesn't, creates it.
# Whilst in desktop modem this file is not written to, so I assume it gets written to whilst in gamemode, or whilst playing a game in or out of gamemode? 
if [ -e /root/.steam/root/config/SteamAppData.vdf ] # Checks if file exists
then
    echo "File '/root/.steam/root/config/SteamAppData.vdf' exists. Skipping file creation."
else
    echo "File '/root/.steam/root/config/SteamAppData.vdf' does not exist. Creating file."
    
    cd /
    cd root || { echo "Error: Could not move into directory '/root'. Are you running as root?"; exit 1; }
     
    if [ -d /root/.steam ]
        then
            echo "Directory '/root/.steam' exists. Skipping directory creation."
            cd .steam || { echo "Error: Could not move into directory '/root/.steam'. Are you running as root?"; exit 1; }
        else
            echo "Directory '/root/.steam' does not exist. Creating directory."
            sudo mkdir .steam
            cd .steam || { echo "Error: Could not move into directory '/root/.steam'. Are you running as root?"; exit 1; }
            echo "Directory '/root/.steam' created"
    fi
    
    if [ -d /root/.steam/root ]
        then
            echo "Directory '/root/.steam/root' exists. Skipping directory creation."
            cd root || { echo "Error: Could not move into directory '/root/.steam/root'. Are you running as root?"; exit 1; }
        else
            echo "Directory '/root/.steam/root' does not exist. Creating directory."
            sudo mkdir root
            cd root || { echo "Error: Could not move into directory '/root/.steam/root'. Are you running as root?"; exit 1; }
            echo "Directory '/root/.steam/root' created"
    fi
    
    if [ -d /root/.steam/root/config ]
        then
            echo "Directory '/root/.steam/root/config' exists. Skipping directory creation."
            cd config || { echo "Error: Could not move into directory '/root/.steam/root/config'. Are you running as root?"; exit 1; }
        else
            echo "Directory '/root/.steam/root/config' does not exist. Creating directory."
            sudo mkdir config
            cd config || { echo "Error: Could not move into directory '/root/.steam/root/config'. Are you running as root?"; exit 1; }
            echo "Directory '/root/.steam/root/config' created"
    fi
    
    sudo touch SteamAppData.vdf
    echo "Created file: '/root/.steam/root/config/SteamAppData.vdf'."
fi

# The variable "XDG_RUNTIME_DIR" seems to not be set properly, causing incorrect system permissions for the users, and seemingly making gamescope fail to initialise.
# The following section will set the variable to the correct value.
echo "export XDG_RUNTIME_DIR=/run/user/1000" >> ~/.pam_environment # Default user ID
echo "export XDG_RUNTIME_DIR=/run/user/1000" >> ~/.bashrc
source ~/.bashrc

sudo holoiso-enable-sessions # Re-enables sessions just in case the user decides to reboot.
sudo holoiso-grub-update # Updates holoiso grub configuration once more, just to be safe

echo "The script has finished running and sessions have been enabled. Try rebooting to test if holoiso now works."