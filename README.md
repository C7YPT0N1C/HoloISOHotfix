# HoloISO Hotfix
***A Hotfix script for the 4.1 HoloISO ISO.***
<br/>***Gist: https://gist.github.com/C7YPT0N1C/5625ef6a40a558ed6584b6ed62a66419***

*NOTES:*

\- *THIS HAS ONLY BEEN TESTED ON INSTALLATIONS THAT USED THE HOLOISO 4.1 ISO*

\- *THIS SCRIPT MUST BE RUN USING SUPERUSER / SUDO SU. IT WILL NOT WORK OTHERWISE.*


<br/>After a bit of tinkering, I've got it to work to a decent level. If this does not work for you, please tell me what happens! Testers are appreciated.

<br/>Instructions:

\- Boot into Holoiso Desktop Mode

\- At this point, Steam Desktop will boot up. You may sign in, but this will skip the SteamOS OOBE. I do recommend to sign in, but if you want / need the OOBE, don't sign in.

\- Open a web browser and download the script above.

\- Extract download.

\- Open folder, right click empty space, and click "Open Terminal Here"

\- In the terminal that appears, run: 
<br/>`sudo su`
<br/>then
<br/>`sudo bash ./HoloISO-4.1-Hotfix.sh`

\- When the script has finished running, reboot, as "return to game mode" seems to be hella buggy.

<br/>Notices:

\- You may have to reboot a few times to fully boot up. If a kernel doesn't work, try a different one.

\- I may update this script if I find a better hotfix. If I do, please redownload and re-run the script. I will code the script to ensure nothing breaks and no useless files are kept.

\- Please keep in mind that when the script runs, mesa-amber will be installed to replace mesa, mesa and mesa-amber both being the 3d graphics library Holoiso / SteamOS use. You can switch to any version of mesa, and see if that works better for you.

\- Please keep in mind that this script *may* have unintended side effects if you have more than 1 user on your system (?).

<br/>***Find full Documentation: https://github.com/users/C7YPT0N1C/projects/4***
