#!/bin/bash

# HOLOISO COMMANDS:
# steamos-update [check|now]
# holoiso-[enable|disable]-sessions
# holoiso-grub-update
# steamos-session-select [plasma|gamescope|plasma-x11-persistent] (CANNOT AND MUST NOT BE RUN AS ROOT)

function PreInstall { # Gives user warnings about the dangers of using the script.
    echo "! WARNING: This script has a chance of screwing up your system. It won't work for everyone, this is a hotfix, not a patch. !"
    echo "! WARNING: Proceed ONLY if you know what you are doing. You alone are responsible for the outcome. !"
}

function InstallInit { # Lets user choose whether to use custom installation options, or just use the recommended ones.
    read -r -p "Would you like to use the recommended settings? [y/n] (Default = n): " choice 
    if [ "$choice" = "y" ]; then
        RecommendedSettings
        #echo "WIP"
        #exit
    
    elif [ "$choice" = "n" ]; then
        echo "! Beginning custom installation. !"

    else # Loop script
        ErrorHandler Invalid
    fi
}

function RecommendedSettings { # Applies recommended settings.
    echo "! Using recommended settings. !"

    RepoSetup
    SoftwareInstall # Calls on rest of the script to run (these parts require no user input).
    SystemUpdate
    VariableSet
    SteamAppDataInit
    PostInstall
}

function RepoSetup { # Sets up repos
    echo "! Repositories for the latest HoloISO version need no changes. !"
}

function SoftwareInstall { # Installs mesa-amber
    pacman -Syyu # Update repos and packages

    read -r -p "Would you like to install mesa-amber? [y/n] (Default = y): " choice # Gives user an option to install mesa-amber (preferred as mesa causes visual artifacts).
    if [ "$choice" = "y" ]; then
        echo "! Installing mesa-amber. !"
        pacman -Syyu mesa-amber # Installs mesa-amber
    
    elif [ "$choice" = "n" ]; then
        echo "! Skipping Installing mesa-amber. !"
        pacman -Syyu mesa # Installs mesa, in case it has been replaced on a different run
    
    else # Loop script
        ErrorHandler Invalid
        SoftwareInstall
    fi

    pacman -Syyu polkit # Installs polkit
}

function SystemUpdate { # Updates
    pacman -Syyu # Reupdates repos and packages just in case, also to prep for potential steamos-update.
    steamos-update check # Checks for SteamOS updates.
    steamos-update now # Updates SteamOS is an update is found.
    holoiso-grub-update # Updates holoiso grub configuration just to be safe.
}

function VariableSet { # Sets environment variables
    # The variable "XDG_RUNTIME_DIR" seems to not be set properly, causing incorrect system permissions for the users, and seemingly making gamescope fail to initialise. The following section will set the variable to the correct value.
    
    XDG_RUNTIME_DIR=/run/user/1000
    export XDG_RUNTIME_DIR >> ~/.pam_environment # Default user ID
    export XDG_RUNTIME_DIR >> ~/.bashrc
    source ~/.bashrc
}

function SteamAppDataInit { # Creates file "/root/.steam/root/config/SteamAppData.vdf"
    echo "! Switching to root user. If prompted, please enter root password. !"
    #su root # Switches user to root to allow for write access to the /root parent directory and it's child directories. # Not needed, the script is ran as root anyways.
    
    
    # The file "/root/.steam/root/config/SteamAppData.vdf" for some reason is required to exist for gamescope to properly initialise, however, it seems that this file is by default not created.
    # The following section will check to see if it exists, and if it doesn't, creates it.
    # Whilst in desktop modem this file is not written to, so I assume it gets written to whilst in gamemode, or whilst playing a game in or out of gamemode? 
    if [ -e /root/.steam/root/config/SteamAppData.vdf ]; then # Checks if file exists
        echo "! File '/root/.steam/root/config/SteamAppData.vdf' exists. Skipping file creation. !"
    
    else # Loop script
        echo "! File '/root/.steam/root/config/SteamAppData.vdf' does not exist. Creating file. !"
        
        cd /
        cd root || { echo "! Error: Could not move into directory '/root'. Are you running as root? !"; exit 1; }
        
        if [ -d /root/.steam ]; then
                echo "! Directory '/root/.steam' exists. Skipping directory creation. !"
                cd .steam || { echo "! Error: Could not move into directory '/root/.steam'. Are you running as root? !"; exit 1; }
        else # Loop script
            echo "! Directory '/root/.steam' does not exist. Creating directory. !"
            mkdir .steam
            cd .steam || { echo "! Error: Could not move into directory '/root/.steam'. Are you running as root? !"; exit 1; }
            echo "! Directory '/root/.steam' created. !"
        fi
            
        if [ -d /root/.steam/root ]; then
            echo "! Directory '/root/.steam/root' exists. Skipping directory creation. !"
            cd root || { echo "! Error: Could not move into directory '/root/.steam/root'. Are you running as root? !"; exit 1; }
        else # Loop script
            echo "! Directory '/root/.steam/root' does not exist. Creating directory. !"
            mkdir root
            cd root || { echo "! Error: Could not move into directory '/root/.steam/root'. Are you running as root? !"; exit 1; }
            echo "! Directory '/root/.steam/root' created. !"
        fi
            
        if [ -d /root/.steam/root/config ]; then
            echo "! Directory '/root/.steam/root/config' exists. Skipping directory creation. !"
            cd config || { echo "! Error: Could not move into directory '/root/.steam/root/config'. Are you running as root? !"; exit 1; }
        else # Loop script
            echo "! Directory '/root/.steam/root/config' does not exist. Creating directory. !"
            mkdir config
            cd config || { echo "! Error: Could not move into directory '/root/.steam/root/config'. Are you running as root? !"; exit 1; }
            echo "! Directory '/root/.steam/root/config' created. !"
        fi
        
        touch SteamAppData.vdf
        echo "! Created file: '/root/.steam/root/config/SteamAppData.vdf'. !"
    fi
}

function PostInstall { # Finishes up installation
    sudo holoiso-enable-sessions # Re-enables sessions just in case the user decides to reboot.
    SystemUpdate
    echo "! The script has finished running and sessions have been enabled. Try rebooting to test if holoiso now works. !"
}

function ErrorHandler { # Handles any errors that may be spat out by the script
    if [ "$choice" = "Unknown" ]; then
        echo "! Idk wtf happened lol, but something broke. !"
    
    elif [ "$choice" = "Invalid" ]; then
        echo "! Invalid Choice. !"
    fi
}

function Main { # Calling functions
    PreInstall
    InstallInit
    RepoSetup
    SoftwareInstall
    SystemUpdate
    VariableSet
    SteamAppDataInit
    PostInstall
}

Main # Run script