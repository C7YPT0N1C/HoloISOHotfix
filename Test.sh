read -r -p "Do you want to use the '-rel' repositories or the '-3.3' repositories?  [rel/3.3] (Default = rel)" choice # Chooses whether to use -rel repos or -3.3 repos
if [ "$choice" = "rel" ]; then
        echo "Selecting '-rel' repositories."
        
        read -r -p "Do you want to use the stable branch?  [y/n] (Default = y)" choice # Chooses whether to use "holoiso-stable" branch or the "holoiso" branch
        if [ "$choice" = "y" ]; then
            echo "Selecting stable branch."

            read -r -p "File '/etc/pacman.conf' will be overwritten. Continue (y/n)?" choice # Update pacman.conf to latest working repos based on selected repositories
            if [ "$choice" = "y" ]; then
                echo "Updating file '/etc/pacman.conf'"
                sudo cp ./pacman/pacman-rel-stable.conf ./pacman.conf
            elif [ "$choice" = "n" ]; then
                echo "Skipping updating file '/etc/pacman.conf'"
            else
                echo "Invalid Answer."
                exit
            fi

        elif [ "$choice" = "n" ]; then
            echo "Deselecting stable branch."

            read -r -p "File '/etc/pacman.conf' will be overwritten. Continue (y/n)?" choice
            if [ "$choice" = "y" ]; then
                echo "Updating file '/etc/pacman.conf'"
                sudo cp ./pacman/pacman-rel-holoiso.conf ./pacman.conf
            elif [ "$choice" = "n" ]; then
                echo "Skipping updating file '/etc/pacman.conf'"
            else
                echo "Invalid Answer."
                exit
            fi
        else
            echo "Invalid Answer."
            exit
        fi

elif [ "$choice" = "3.3" ]; then
        echo "Selecting '-3.3' repositories."

        read -r -p "Do you want to use the stable branch?  [y/n] (Default = y)" choice
        if [ "$choice" = "y" ]; then
            echo "Selecting stable branch."

            read -r -p "File '/etc/pacman.conf' will be overwritten. Continue (y/n)?" choice
            if [ "$choice" = "y" ]; then
                echo "Updating file '/etc/pacman.conf'"
                sudo cp ./pacman/pacman-3.3-stable.conf ./pacman.conf
            elif [ "$choice" = "n" ]; then
                echo "Skipping updating file '/etc/pacman.conf'"
            else
                echo "Invalid Answer."
                exit
            fi

        elif [ "$choice" = "n" ]; then
            echo "Deselecting stable branch."

            read -r -p "File '/etc/pacman.conf' will be overwritten. Continue (y/n)?" choice
            if [ "$choice" = "y" ]; then
                echo "Updating file '/etc/pacman.conf'"
                sudo cp ./pacman/pacman-3.3-holoiso.conf ./pacman.conf
            elif [ "$choice" = "n" ]; then
                echo "Skipping updating file '/etc/pacman.conf'"
            else
                echo "Invalid Answer."
                exit
            fi
            
        else
            echo "Invalid Answer."
            exit
        fi
else
        echo "Invalid Answer."
        exit
fi