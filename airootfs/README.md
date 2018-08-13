# Reborn-OS
![Deepin_Image](/images/deepin.png)

## Download Locations ##
- <a href="https://sourceforge.net/projects/antergos-deepin/" class="button">Sourceforge</a> 

### About Airootfs

The `airootfs` folder is kind of like a virtual system. Basically, the `build.sh` script treats the `airootfs` folder as the `/` one on your real system. But through this, it is able to isolate itself from your system, kind of like Docker. 

### How to Add Files (And Remove Them)

**Add Files:**
- Simply treat the `airootfs` folder as your root one (`/`) and as such, begin branching out from here. You can already see the `etc` folder present, among others. As such, just create the path, starting from root, to your desired addition in the system and add it in.
- **Exception**: the `Home` folder. This folder is not present or understood by the `build.sh` script. Instead, it uses the `airootfs/etc/skel` folder as your future home folder. Therefore, to add a file to hte ISOs Home directory, all you need to do is add your file to that `skel` folder.

**Remove Files:**
- Same as adding, but reverse! Delete away my friend.
