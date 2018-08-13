# Reborn-OS
![Deepin_Image](/images/deepin.png)

## Download Locations ##
- <a href="https://sourceforge.net/projects/antergos-deepin/" class="button">Sourceforge</a> 

### About Airootfs

The `airootfs` folder is kind of like a virtual system. Basically, the `build.sh` script treats the `airootfs` folder as the `/` one on your real system. But through this, it is able to isolate itself from your system, kind of like Docker. 

### How to Add Files (And Remove Them)

**Add Files:**
- Simply treat the `airootfs` folder as your root one (`/`) and as such, begin branching out from here. You can already see the `etc` folder present, among others. As such, just create the path, starting from root, to your desired addition in the system and add it in.
- **Exception**: the `Home` folder. This folder is not present or understood by the `build.sh` script. Instead, it uses the `airootfs/etc/skel` folder as your future home folder. Therefore, to add a file to the ISOs Home directory, all you need to do is add your file to that `skel` folder.
- **One more exception**: the `root` folder. This folder is simply used by the `build.sh` script to store building commands that are intended to be isolated to the future ISO's system, and cannot run at all on your full, real system. As such, you can find the `customize_airootfs.sh` script inside there, which `build.sh` called up in its build to run special commands that should only have an impact on the future ISO - such as enabling certain systemd modules.

**Remove Files:**
- Same as adding, but reverse! Delete away my friend.
