#!/bin/bash

# HOLOISO COMMANDS:
# steamos-update [check|now]
# holoiso-[enable|disable]-sessions
# holoiso-grub-update
# steamos-session-select [plasma|gamescope|plasma-x11-persistent] (CANNOT AND MUST NOT BE RUN AS ROOT)

function PreInstall {
    echo "! WARNING: This script has a chance of screwing up your system. It won't work for everyone, this is a hotfix, not a patch. !"
    echo "! WARNING: Proceed ONLY if you know what you are doing. You alone are responsible for the outcome. !"
}

function RecommendedSettings {
    read -r -p "Would you like to use the recommended settings? [y/n] (Default = n): " choice # Lets user choose whether to use custom installation options, or just use the recommended ones
    if [ "$choice" = "y" ]; then
        echo "! Using recommended settings. !"

        echo "WIP"
        exit
    else # Exit script
        echo "! Beginning custom installation. !"
    fi
}

function RepoSetup {
    echo "! Beginning repository setup. !"

    read -r -p "Do you want to use the '-rel' repositories or the '-3.3' repositories?  [rel/3.3] (Default = rel): " choice # Chooses whether to use -rel repos or -3.3 repos
    if [ "$choice" = "rel" ]; then
            echo "! Selecting '-rel' repositories. !"
            
            read -r -p "Do you want to use the stable branch?  [y/n] (Default = y): " choice # Chooses whether to use "holoiso-stable" branch or the "holoiso" branch
            if [ "$choice" = "y" ]; then
                echo "! Selecting stable branch. !"

                read -r -p "File '/etc/pacman.conf' will be backed up then overwritten. Continue? [y/n] (Default = y): " choice # Update pacman.conf to latest working repos based on selected repositories
                if [ "$choice" = "y" ]; then
                    echo "! Updating file '/etc/pacman.conf'. !"
                    sudo cp ./pacman/pacman-rel-stable.conf ./pacman.conf # Move template of selected repo to empty pacman.conf file
                    sudo cp /etc/pacman.conf /etc/pacman.conf.bak # User's pacman.conf file is backed up
                    sudo cp ./pacman.conf /etc/pacman.conf # New pacman.conf file is moved into system
                elif [ "$choice" = "n" ]; then
                    echo "! Skipping updating file '/etc/pacman.conf'. !"
                else # Exit script
                    echo "! Invalid Answer. !"
                    RepoSetup
                fi

            elif [ "$choice" = "n" ]; then
                echo "! Deselecting stable branch. !"

                read -r -p "File '/etc/pacman.conf' will be backed up then overwritten. Continue? [y/n] (Default = y): " choice
                if [ "$choice" = "y" ]; then
                    echo "! Updating file '/etc/pacman.conf'. !"
                    sudo cp ./pacman/pacman-rel-holoiso.conf ./pacman.conf # Move template of selected repo to empty pacman.conf file
                    sudo cp /etc/pacman.conf /etc/pacman.conf.bak # User's pacman.conf file is backed up
                    sudo cp ./pacman.conf /etc/pacman.conf # New pacman.conf file is moved into system
                elif [ "$choice" = "n" ]; then
                    echo "! Skipping updating file '/etc/pacman.conf'. !"
                else # Exit script
                    echo "! Invalid Answer. !"
                    RepoSetup
                fi
            else # Exit script
                echo "! Invalid Answer. !"
                RepoSetup
            fi

    elif [ "$choice" = "3.3" ]; then
            echo "! Selecting '-3.3' repositories. !"

            read -r -p "Do you want to use the stable branch?  [y/n] (Default = y): " choice
            if [ "$choice" = "y" ]; then
                echo "! Selecting stable branch. !"

                read -r -p "File '/etc/pacman.conf' will be backed up then overwritten. Continue? [y/n] (Default = y): " choice
                if [ "$choice" = "y" ]; then
                    echo "! Updating file '/etc/pacman.conf'. !"
                    sudo cp ./pacman/pacman-3.3-stable.conf ./pacman.conf # Move template of selected repo to empty pacman.conf file
                    sudo cp /etc/pacman.conf /etc/pacman.conf.bak # User's pacman.conf file is backed up
                    sudo cp ./pacman.conf /etc/pacman.conf # New pacman.conf file is moved into system
                elif [ "$choice" = "n" ]; then
                    echo "! Skipping updating file '/etc/pacman.conf'. !"
                else # Exit script
                    echo "! Invalid Answer. !"
                    RepoSetup
                fi

            elif [ "$choice" = "n" ]; then
                echo "! Deselecting stable branch. !"

                read -r -p "File '/etc/pacman.conf' will be backed up then overwritten. Continue? [y/n] (Default = y): " choice
                if [ "$choice" = "y" ]; then
                    echo "! Updating file '/etc/pacman.conf'. !"
                    sudo cp ./pacman/pacman-3.3-holoiso.conf ./pacman.conf # Move template of selected repo to empty pacman.conf file
                    sudo cp /etc/pacman.conf /etc/pacman.conf.bak # User's pacman.conf file is backed up
                    sudo cp ./pacman.conf /etc/pacman.conf # New pacman.conf file is moved into system
                elif [ "$choice" = "n" ]; then
                    echo "! Skipping updating file '/etc/pacman.conf'. !"
                else # Exit script
                    echo "! Invalid Answer. !"
                    RepoSetup
                fi
                
            else # Exit script
                echo "! Invalid Answer. !"
                RepoSetup
            fi
    else # Exit script
            echo "! Invalid Answer. !"
            RepoSetup
    fi
}

function MesaInstall {
    sudo pacman -Syyu # Update repos and packages

    read -r -p "Would you like to install mesa-amber? [y/n] (Default = y): " choice # Gives user an option to install mesa-amber (preffered as mesa causes visual artifacts)
    if [ "$choice" = "y" ]; then
        echo "! Installing mesa-amber. !"
        sudo pacman -Syu mesa-amber # Installs mesa-amber
    elif [ "$choice" = "n" ]; then
        echo "! Skipping Installing mesa-amber. !"
    else # Exit script
        echo "! Invalid Answer. !"
        MesaInstall
    fi
}

function SysUpdate {
    sudo pacman -Syu polkit # Installs polkit
    sudo pacman -Syyu # Reupdates repos and packages just in case, also to prep for potential steamos-update
    sudo steamos-update check # Checks for SteamOS updates
    sudo steamos-update now # Updates SteamOS is an update is found 
    sudo holoiso-grub-update # Updates holoiso grub configuration just to be safe
}

function VariableSet {
    # The variable "XDG_RUNTIME_DIR" seems to not be set properly, causing incorrect system permissions for the users, and seemingly making gamescope fail to initialise.
    # The following section will set the variable to the correct value.
    sudo echo "export XDG_RUNTIME_DIR=/run/user/1000" >> ~/.pam_environment # Default user ID
    sudo echo "export XDG_RUNTIME_DIR=/run/user/1000" >> ~/.bashrc
    source ~/.bashrc
}

function SteamAppDataCreate {
    # The file "/root/.steam/root/config/SteamAppData.vdf" for some reason is required to exist for gamescope to properly initialise, however, it seems that this file is by default not created.
    # The following section will check to see if it exists, and if it doesn't, creates it.
    # Whilst in desktop modem this file is not written to, so I assume it gets written to whilst in gamemode, or whilst playing a game in or out of gamemode? 
    if [ -e /root/.steam/root/config/SteamAppData.vdf ] # Checks if file exists
    then
        echo "! File '/root/.steam/root/config/SteamAppData.vdf' exists. Skipping file creation. !"
    else # Exit script
        echo "! File '/root/.steam/root/config/SteamAppData.vdf' does not exist. Creating file. !"
        
        cd /
        cd root || { echo "! Error: Could not move into directory '/root'. Are you running as root? !"; exit 1; }
        
        if [ -d /root/.steam ]; then
                echo "! Directory '/root/.steam' exists. Skipping directory creation. !"
                cd .steam || { echo "! Error: Could not move into directory '/root/.steam'. Are you running as root? !"; exit 1; }
            else # Exit script
                echo "! Directory '/root/.steam' does not exist. Creating directory. !"
                sudo mkdir .steam
                cd .steam || { echo "! Error: Could not move into directory '/root/.steam'. Are you running as root? !"; exit 1; }
                echo "! Directory '/root/.steam' created. !"
            fi
            
            if [ -d /root/.steam/root ]; then
                echo "! Directory '/root/.steam/root' exists. Skipping directory creation. !"
                cd root || { echo "! Error: Could not move into directory '/root/.steam/root'. Are you running as root? !"; exit 1; }
            else # Exit script
                echo "! Directory '/root/.steam/root' does not exist. Creating directory. !"
                sudo mkdir root
                cd root || { echo "! Error: Could not move into directory '/root/.steam/root'. Are you running as root? !"; exit 1; }
                echo "! Directory '/root/.steam/root' created. !"
            fi
            
            if [ -d /root/.steam/root/config ]; then
                echo "! Directory '/root/.steam/root/config' exists. Skipping directory creation. !"
                cd config || { echo "! Error: Could not move into directory '/root/.steam/root/config'. Are you running as root? !"; exit 1; }
            else # Exit script
                echo "! Directory '/root/.steam/root/config' does not exist. Creating directory. !"
                sudo mkdir config
                cd config || { echo "! Error: Could not move into directory '/root/.steam/root/config'. Are you running as root? !"; exit 1; }
                echo "! Directory '/root/.steam/root/config' created. !"
            fi
        
        sudo touch SteamAppData.vdf
        echo "! Created file: '/root/.steam/root/config/SteamAppData.vdf'. !"
    fi
}

function PostInstall {
    sudo holoiso-enable-sessions # Re-enables sessions just in case the user decides to reboot.
    sudo holoiso-grub-update # Updates holoiso grub configuration once more, just to be safe

    echo "! The script has finished running and sessions have been enabled. Try rebooting to test if holoiso now works. !"
}

function Main { # CALLING FUNCTIONS
    PreInstall
    RecommendedSettings
    RepoSetup
    MesaInstall
    SysUpdate
    VariableSet
    SteamAppDataCreate
    PostInstall
}

Main