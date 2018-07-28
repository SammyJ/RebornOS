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
sudo pacman -S arch-install-scripts cpio dosfstools libisoburn mkinitcpio-nfs-utils make patch squashfs-tools wget lynx archiso reflector-antergos --noconfirm --needed
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

### Upload Reborn OS to Sourceforge (note for Reborn OS team)

- Run `rsync -v --progress -e ssh /home/$USER/reborn/out/Reborn-OS-2017.12.13-x86_64.iso {SOURCEFORGE_USER_NAME}@frs.sourceforge.net:/home/frs/project/antergos-deepin/
`

### Upload Reborn OS code to Gitlab (note for Reborn OS team)
- Follow the instructions found here: https://help.github.com/articles/adding-a-file-to-a-repository-using-the-command-line/
