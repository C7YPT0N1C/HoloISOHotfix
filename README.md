# HoloISO-Hotfix
***A Hotfix script for the 4.1 HoloISO ISO.***
<br/>***Gist: https://gist.github.com/C7YPT0N1C/5625ef6a40a558ed6584b6ed62a66419***

*NOTES:*

\- *THIS HAS ONLY BEEN TESTED ON INSTALLATIONS THAT USED THE HOLOISO 4.1 ISO*

\- *THIS SCRIPT MUST BE RUN USING SUPERUSER / SUDO SU. IT WILL NOT WORK OTHERWISE.*


<br/>After a bit of tinkering, I've got it to work to a decent level. If this does not work for you, please tell me what happens! Testers are appreciated.

&#x200B;

\- Boot into Holoiso Desktop Mode

\- At this point, Steam Desktop will boot up. You may sign in, but this will skip the SteamOS OOBE. I do recommend to sign in, but if you want / need the OOBE, don't sign in.

\- Open a web browser and download the script above.

\- Extract download.

\- Open folder, right click empty space, and click "Open Terminal Here"

\- In the terminal that appears, run: 
`sudo su`
`sudo bash ./HoloISO-4.1-Hotfix.sh`

\- When the script has finished running, reboot, as "return to game mode" seems to be hellu buggy.

&#x200B;

Notices:

\- You may have to reboot a few times to fully boot up. If a kernel doesn't work, try a different one.

\- I may update this script if I find a better hotfix. If I do, please redownload and re-run the script. I will code the script to ensure nothing breaks and no useless files are kept.

\- Please keep in mind that when the script runs, mesa-amber will be installed to replace mesa, mesa and mesa-amber both being the 3d graphics library Holoiso / SteamOS use. You can switch to any version of mesa, and see if that works better for you.

\- Please keep in mind that this script *may* have unintended side effects if you have more than 1 user on your system (?).

&#x200B;

What It Fixes:

\- Fixes the update screen showing up all weird

\- Seems to fix the update loop, where it shows update screen, shows boot animation, cuts back to update screen.

\- Fixes prominent gamescope crashes.

&#x200B;

Problems:

\- Doesn't play nice with the SteamOS kernel (the default).

\- The install still may might loop the update screen (shows update screen, shows boot animation, cuts back to update screen), although it does seem to eventually work after a few retries / reboots (?). Switching from the SteamOS kernel to the holoiso kernel (and vice versa) seems to fix this.

\- The UI may seem slower / of a lesser quality, probably due to mesa-amber.

\- Occasional visual glitches.

\- Seeming because mesa-amber is installed, choosing a performance overlay level  higher than 0 will glitch the screen temporarily. Switching the level  back to zero, or closing out of the quick settings menu will change this  back.

\- "Return to Game Mode" seems kinda buggy, sometimes working, mostly not.

&#x200B;

Please Test:
\- (?) = Further testing required / requested

\- General HoloISO features

\- Logout and back into a gamescope session instead of using "Return to gaming mode".

\- Using Nvidia graphics cards

\- Booting without WiFi

\- Using SteamOS kernel
