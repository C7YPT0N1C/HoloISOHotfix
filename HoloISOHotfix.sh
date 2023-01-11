#!/bin/bash

# HOLOISO COMMANDS:
# steamos-update [check|now]
# holoiso-[enable|disable]-sessions
# holoiso-grub-update
# steamos-session-select [plasma|gamescope|plasma-x11-persistent] (CANNOT AND MUST NOT BE RUN AS ROOT)

function PreInstall { # Gives user warnings about the dangers of using the script
    echo "! WARNING: This script has a chance of screwing up your system. It won't work for everyone, this is a hotfix, not a patch. !"
    echo "! WARNING: Proceed ONLY if you know what you are doing. You alone are responsible for the outcome. !"
}

function InstallInit { # Lets user choose whether to use custom installation options, or just use the recommended ones
    read -r -p "Would you like to use the recommended settings? [y/n] (Default = n): " choice 
    if [ "$choice" = "y" ]; then
        RecommendedSettings
        #echo "WIP"
        #exit
    else # Loop script
        echo "! Beginning custom installation. !"
    fi
}

function RecommendedSettings { # Applies recommended settings
    echo "! Using recommended settings. !"

    echo "! Using branch 'stable' of '-rel' repository. !" # Update repos
    sudo cp ./pacman/pacman-rel-stable.conf ./pacman.conf # Move template of selected repo to empty pacman.conf file
    echo "! Backing up file '/etc/pacman.conf'. !"
    sudo cp /etc/pacman.conf /etc/pacman.conf.bak # User's pacman.conf file is backed up
    echo "! Updating file'/etc/pacman.conf'. !"
    sudo cp ./pacman.conf /etc/pacman.conf # New pacman.conf file is moved into system

    MesaInstall # Rest of script is unattended anyways
    SysUpdate
    VariableSet
    SteamAppDataInit
    PostInstall
}

function RepoSetup { # Sets up repos
    echo "! Beginning repository setup. !"

    read -r -p "Do you want to use the '-rel' repositories or the '-3.3' repositories?  [rel/3.3] (Default = rel): " choice # Chooses whether to use -rel repos or -3.3 repos
    if [ "$choice" = "rel" ]; then
            echo "! Selecting '-rel' repositories. !" # "-rel" repos chosen
            
            read -r -p "Do you want to use the stable branch?  [y/n] (Default = y): " choice # Chooses whether to use "holoiso-stable" branch or the "holoiso" branch
            if [ "$choice" = "y" ]; then
                echo "! Selecting stable branch. !" # Stable branch chosen

                read -r -p "File '/etc/pacman.conf' will be backed up then overwritten. Continue? [y/n] (Default = y): " choice # Update pacman.conf to latest working repos based on selected repositories
                if [ "$choice" = "y" ]; then
                    echo "! Updating file '/etc/pacman.conf'. !"
                    sudo cp ./pacman/pacman-rel-stable.conf ./pacman.conf # Move template of selected repo to empty pacman.conf file
                    sudo cp /etc/pacman.conf /etc/pacman.conf.bak # User's pacman.conf file is backed up
                    sudo cp ./pacman.conf /etc/pacman.conf # New pacman.conf file is moved into system
                elif [ "$choice" = "n" ]; then
                    echo "! Skipping updating file '/etc/pacman.conf'. !"
                else # Loop script
                    echo "! Invalid Answer. !"
                    RepoSetup
                fi

            elif [ "$choice" = "n" ]; then
                echo "! Deselecting stable branch. !" # "Unstable" branch chosen

                read -r -p "File '/etc/pacman.conf' will be backed up then overwritten. Continue? [y/n] (Default = y): " choice # Update pacman.conf to latest working repos based on selected repositories
                if [ "$choice" = "y" ]; then
                    echo "! Updating file '/etc/pacman.conf'. !"
                    sudo cp ./pacman/pacman-rel-holoiso.conf ./pacman.conf
                    sudo cp /etc/pacman.conf /etc/pacman.conf.bak
                    sudo cp ./pacman.conf /etc/pacman.conf
                elif [ "$choice" = "n" ]; then
                    echo "! Skipping updating file '/etc/pacman.conf'. !"
                else # Loop script
                    echo "! Invalid Answer. !"
                    RepoSetup
                fi
            else # Loop script
                echo "! Invalid Answer. !"
                RepoSetup
            fi

    elif [ "$choice" = "3.3" ]; then
            echo "! Selecting '-3.3' repositories. !" # "-3.3" repos chosen

            read -r -p "Do you want to use the stable branch?  [y/n] (Default = y): " choice # Chooses whether to use "holoiso-stable" branch or the "holoiso" branch
            if [ "$choice" = "y" ]; then
                echo "! Selecting stable branch. !" # Stable branch chosen

                read -r -p "File '/etc/pacman.conf' will be backed up then overwritten. Continue? [y/n] (Default = y): " choice
                if [ "$choice" = "y" ]; then
                    echo "! Updating file '/etc/pacman.conf'. !"
                    sudo cp ./pacman/pacman-3.3-stable.conf ./pacman.conf
                    sudo cp /etc/pacman.conf /etc/pacman.conf.bak
                    sudo cp ./pacman.conf /etc/pacman.conf
                elif [ "$choice" = "n" ]; then
                    echo "! Skipping updating file '/etc/pacman.conf'. !"
                else # Loop script
                    echo "! Invalid Answer. !"
                    RepoSetup
                fi

            elif [ "$choice" = "n" ]; then
                echo "! Deselecting stable branch. !" # "Unstable" branch chosen

                read -r -p "File '/etc/pacman.conf' will be backed up then overwritten. Continue? [y/n] (Default = y): " choice
                if [ "$choice" = "y" ]; then
                    echo "! Updating file '/etc/pacman.conf'. !"
                    sudo cp ./pacman/pacman-3.3-holoiso.conf ./pacman.conf
                    sudo cp /etc/pacman.conf /etc/pacman.conf.bak
                    sudo cp ./pacman.conf /etc/pacman.conf
                elif [ "$choice" = "n" ]; then
                    echo "! Skipping updating file '/etc/pacman.conf'. !"
                else # Loop script
                    echo "! Invalid Answer. !"
                    RepoSetup
                fi
                
            else # Loop script
                echo "! Invalid Answer. !"
                RepoSetup
            fi
    else # Loop script
            echo "! Invalid Answer. !"
            RepoSetup
    fi
}

function MesaInstall { # Installs mesa-amber
    sudo pacman -Syyu # Update repos and packages

    read -r -p "Would you like to install mesa-amber? [y/n] (Default = y): " choice # Gives user an option to install mesa-amber (preffered as mesa causes visual artifacts)
    if [ "$choice" = "y" ]; then
        echo "! Installing mesa-amber. !"
        sudo pacman -Syu mesa-amber # Installs mesa-amber
    elif [ "$choice" = "n" ]; then
        echo "! Skipping Installing mesa-amber. !"
    else # Loop script
        echo "! Invalid Answer. !"
        MesaInstall
    fi
}

function SysUpdate { # Updates
    sudo pacman -Syu polkit # Installs polkit
    sudo pacman -Syyu # Reupdates repos and packages just in case, also to prep for potential steamos-update
    sudo steamos-update check # Checks for SteamOS updates
    sudo steamos-update now # Updates SteamOS is an update is found 
    sudo holoiso-grub-update # Updates holoiso grub configuration just to be safe
}

function VariableSet { # Sets environment variables
    echo "! Switching to root user. If prompted, please enter root password. !"
    su root # Switches user to root to allow for write access to the /root parent directory and it's child directories 
    
    # The variable "XDG_RUNTIME_DIR" seems to not be set properly, causing incorrect system permissions for the users, and seemingly making gamescope fail to initialise.
    # The following section will set the variable to the correct value.
    
    # Old version
    #sudo echo "export XDG_RUNTIME_DIR=/run/user/1000" >> ~/.pam_environment # Default user ID
    #sudo echo "export XDG_RUNTIME_DIR=/run/user/1000" >> ~/.bashrc

    # New version
    XDG_RUNTIME_DIR=/run/user/1000
    export XDG_RUNTIME_DIR >> ~/.pam_environment # Default user ID
    export XDG_RUNTIME_DIR >> ~/.bashrc
    source ~/.bashrc
}

function SteamAppDataInit { # Creates file "/root/.steam/root/config/SteamAppData.vdf"
    echo "! Switching to root account. If prompted, enter root password. !"
    su root # Switch to root to allow manipulation of /root directory and child directories. 
    
    
    # The file "/root/.steam/root/config/SteamAppData.vdf" for some reason is required to exist for gamescope to properly initialise, however, it seems that this file is by default not created.
    # The following section will check to see if it exists, and if it doesn't, creates it.
    # Whilst in desktop modem this file is not written to, so I assume it gets written to whilst in gamemode, or whilst playing a game in or out of gamemode? 
    if [ -e /root/.steam/root/config/SteamAppData.vdf ] # Checks if file exists
    then
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
                sudo mkdir .steam
                cd .steam || { echo "! Error: Could not move into directory '/root/.steam'. Are you running as root? !"; exit 1; }
                echo "! Directory '/root/.steam' created. !"
            fi
            
            if [ -d /root/.steam/root ]; then
                echo "! Directory '/root/.steam/root' exists. Skipping directory creation. !"
                cd root || { echo "! Error: Could not move into directory '/root/.steam/root'. Are you running as root? !"; exit 1; }
            else # Loop script
                echo "! Directory '/root/.steam/root' does not exist. Creating directory. !"
                sudo mkdir root
                cd root || { echo "! Error: Could not move into directory '/root/.steam/root'. Are you running as root? !"; exit 1; }
                echo "! Directory '/root/.steam/root' created. !"
            fi
            
            if [ -d /root/.steam/root/config ]; then
                echo "! Directory '/root/.steam/root/config' exists. Skipping directory creation. !"
                cd config || { echo "! Error: Could not move into directory '/root/.steam/root/config'. Are you running as root? !"; exit 1; }
            else # Loop script
                echo "! Directory '/root/.steam/root/config' does not exist. Creating directory. !"
                sudo mkdir config
                cd config || { echo "! Error: Could not move into directory '/root/.steam/root/config'. Are you running as root? !"; exit 1; }
                echo "! Directory '/root/.steam/root/config' created. !"
            fi
        
        sudo touch SteamAppData.vdf
        echo "! Created file: '/root/.steam/root/config/SteamAppData.vdf'. !"
    fi
}

function PostInstall { # Finishes up installation
    sudo holoiso-enable-sessions # Re-enables sessions just in case the user decides to reboot.
    sudo holoiso-grub-update # Updates holoiso grub configuration once more, just to be safe

    echo "! The script has finished running and sessions have been enabled. Try rebooting to test if holoiso now works. !"
}

function Main { # CALLING FUNCTIONS
    PreInstall
    InstallInit
    RepoSetup
    MesaInstall
    SysUpdate
    VariableSet
    SteamAppDataInit
    PostInstall
}

Main # Run script