# Reborn-OS
![Deepin_Image](/images/deepin.png)

## Download Locations ##
- <a href="https://sourceforge.net/projects/antergos-deepin/" class="button">Sourceforge</a> 

# To Manually Build Yourself

### Dependencies
- isolinux/syslinux
- arch-install-scripts
- cpio
- dosfstools
- git 
- libisoburn
- mkinitcpio-nfs-utils
- make
- opendesktop-fonts
- patch
- squashfs-tools
- archiso
- lynx
- wget
- reflector-antergos

### Free space

Please check that you have 5GB (or more) of free harddisk space in your root partition:
`df -h /`

### Instructions

1. Install dependencies:
```
sudo pacman -S arch-install-scripts cpio dosfstools git libisoburn mkinitcpio-nfs-utils make patch squashfs-tools wget lynx archiso reflector-antergos --noconfirm --needed
```
2. Clone the repository recursively:
```
git clone https://gitlab.com/RebornOS/RebornOS.git --recursive
```
4. Create an `out` folder by running:
```
sudo mkdir out
```
5. Begin building it:
```
sudo ./build.sh -v
```

### That's it!

To rebuild the ISO, simply remove the `build` folder in addition to emptying the `out` folder. Next, re-enter the command from step 5.

### Update to the Newest Code

Say you've done all the steps above a few days ago, but since then new code has been pushed on up to Gitlab here. Instead of having to go through the process of this all over again, you can simply use these quick steps to update things for you. 

1. Make sure your `build` folder is removed and your `out` folder is empty.
2. Update everything with this command:
```
git pull origin master
```
3. Actually, there is no third step. You're all done and good to go!

### Test the Latest and Greatest Code out for Cnchi WITHOUT Building an ISO

1. Just open a terminal and navigate to your `RebornOS` folder.
2. Simply type this in, and you're all done!
```
sudo ./test-cnchi.sh
```
3. Enjoy!

### Upload Reborn OS to Sourceforge (note for Reborn OS team)

- Run `rsync -v --progress -e ssh /home/$USER/reborn/out/Reborn-OS-2017.12.13-x86_64.iso {SOURCEFORGE_USER_NAME}@frs.sourceforge.net:/home/frs/project/antergos-deepin/
`

### Upload Reborn OS code to Gitlab (note for Reborn OS team)
- Follow the instructions found here: https://help.github.com/articles/adding-a-file-to-a-repository-using-the-command-line/
