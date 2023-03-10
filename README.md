# HoloISO Hotfix
***A Hotfix script for HoloISO ISO Issues.***
<br/>***Gist (Deprecated): https://gist.github.com/C7YPT0N1C/5625ef6a40a558ed6584b6ed62a66419***

**UPDATES (Please read notes at the bottom):**
- Added QoL features:
<br/>- Users can now select a to use the "-rel" or "-3.3" SteamOS repositories.
<br/>- Users can now choose whether to use the stable branch of the "-rel" or "-3.3" SteamOS repositories or not.
<br/>- Users can now choose whether to install mesa-amber or not.
- **Full Changelog**: https://github.com/C7YPT0N1C/HoloISO-Hotfix/compare/v1.2.0-stable...v2.0.0-beta


<br/>After a bit of tinkering, I've got it to work to a decent level. If this does not work for you, please tell me what happens! Testers are appreciated.

<br/>**Instructions:**

\- Boot into Holoiso Desktop Mode

\- At this point, Steam Desktop will boot up. You may sign in, but this will skip the SteamOS OOBE. I do recommend to sign in, but if you want / need the OOBE, don't sign in.

\- Open a web browser and download the script above.

\- Extract download.

\- Open folder, right click empty space, and click "Open Terminal Here"

\- In the terminal that appears, run: 
<br/>`sudo su`
<br/>then
<br/>`sudo bash ./HoloISOHotfix.sh`

\- When the script has finished running, reboot, as "return to game mode" seems to be hella buggy.

<br/>**NOTES:**

\- *THIS HAS ONLY BEEN TESTED ON INSTALLATIONS THAT USED THE HOLOISO 4.1 ISO*
<br/>\- *THIS SCRIPT MUST BE RUN USING SUPERUSER / SUDO SU. IT WILL NOT WORK OTHERWISE.*
<br/>\- You may have to reboot a few times to fully boot up. If a kernel doesn't work, try a different one.
<br/>\- I may update this script if I find a better hotfix. If I do, please redownload and re-run the script. I will code the script to ensure nothing breaks and no useless files are kept.
<br/>\- Please keep in mind that when the script runs, mesa-amber will be installed to replace mesa, mesa and mesa-amber both being the 3d graphics library Holoiso / SteamOS use. You can switch to any version of mesa, and see if that works better for you.
<br/>\- Please keep in mind that this script *may* have unintended side effects if you have more than 1 user on your system (?).

<br/>***Full Documentation: https://github.com/users/C7YPT0N1C/projects/4***
