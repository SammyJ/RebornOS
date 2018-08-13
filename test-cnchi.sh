#!/bin/bash
##############################
# Script to download and install Cnchi #
##############################


# Defining Variables
export CNCHI_GIT_BRANCH="0.14.426"
export CNCHI_GIT_URL="https://github.com/Antergos/Cnchi/archive/${CNCHI_GIT_BRANCH}.zip"
export script_path="/usr/share"
export REBORN="/usr/share/cnchi/reborn"

QUESTION(){
echo
echo "Do you want Cnchi to be wiped from your system, without building anything new?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) REMOVE; break;;
        No ) RUN;break;;
    esac
done
}

# Removing Cnchi files if they exist
REMOVE(){
echo
echo "REMOVING ALL INSTALLED INSTANCES OF CNCHI..."
if [ -f /usr/share/cnchi/bin/cnchi ]; then
rm -rf /usr/share/cnchi
rm -f /usr/bin/cnchi
rm -f /usr/share/applications/cnchi.desktop
rm -f /usr/share/pixmaps/cnchi.png
fi
echo "DONE"
}
# Downloading and installing Cnchi
INSTALL(){
echo
echo "#########################################################"
echo "########## DOWNLOADING & INSTALLING CNCHI... ############"
echo "#########################################################"
echo
    wget "${CNCHI_GIT_URL}" -O ${script_path}/cnchi-git.zip
    unzip ${script_path}/cnchi-git.zip -d ${script_path}
    rm -f ${script_path}/cnchi-git.zip
    CNCHI_SRC="${script_path}/Cnchi-${CNCHI_GIT_BRANCH}"
        install -d ${script_path}/{cnchi,locale}
	install -Dm755 "${CNCHI_SRC}/bin/cnchi" "/usr/bin/cnchi"
         echo
         echo "COPIED STARTUP FILE OVER"
         echo
	install -Dm755 "${CNCHI_SRC}/cnchi.desktop" "/usr/share/applications/cnchi.desktop"
         echo
         echo "COPIED DESKTOP FILE OVER"
         echo
	install -Dm644 "${CNCHI_SRC}/data/images/antergos/antergos-icon.png" "/usr/share/pixmaps/cnchi.png"
         echo
         echo "COPIED CNCHI ICON OVER"
         echo
    # TODO: This should be included in Cnchi's src code as a separate file
    # (as both files are needed to run cnchi)
    sed -r -i 's|\/usr.+ -v|pkexec /usr/share/cnchi/bin/cnchi -s bugsnag|g' "/usr/bin/cnchi"
    echo
    echo "MODIFIED STARTUP COMMAND FOR CNCHI"
    echo
    for i in ${CNCHI_SRC}/src ${CNCHI_SRC}/bin ${CNCHI_SRC}/data ${CNCHI_SRC}/scripts ${CNCHI_SRC}/ui; do
        cp -R ${i} "${script_path}/cnchi/"
        echo
        echo "COPIED MAIN CNCHI'S SUBDIRECTORIES OVER TO BUILD FOLDER"
        echo
    done
    for files in ${CNCHI_SRC}/po/*; do
        if [ -f "$files" ] && [ "$files" != 'po/cnchi.pot' ]; then
            STRING_PO=`echo ${files#*/}`
            STRING=`echo ${STRING_PO%.po}`
            mkdir -p /usr/share/locale/${STRING}/LC_MESSAGES
            msgfmt $files -o /usr/share/locale/${STRING}/LC_MESSAGES/cnchi.mo
            echo "${STRING} installed..."
            echo "CNCHI IS NOW BUILT"
        fi
    done
rm -rf ${script_path}/Cnchi-${CNCHI_GIT_BRANCH}
}

# Ask whether or not to use experimental files for Cnchi
ASK(){
echo
echo
echo "Do you wish to use our experimental files for Cnchi?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) DOWNLOAD_EXPERIMENTAL; break;;
        No ) DOWNLOAD_SIMPLE;break;;
    esac
done
}

# Download Reborn's experimental files
DOWNLOAD_EXPERIMENTAL(){
echo
echo
echo "Great! Just know that the experimental files are just that - experimental."
echo "As such, they are in progress and may not work. You've been warned!"
echo
echo "DOWNLOADING SPECIAL REBORN FILES FOR CNCHI (EXPERIMENTAL)..."
echo
echo
cd /
cd /usr/share/cnchi/
mkdir $REBORN
git clone https://gitlab.com/RebornOS/RebornOS.git --recursive
mv /usr/share/cnchi/RebornOS/images $REBORN/images
cd /
cd /tmp/
git clone https://gitlab.com/Azaiel/RebornOS-Cnchi-Modified.git --recursive
mv /tmp/RebornOS-Cnchi-Modified $REBORN/Cnchi
cd /
cd /usr/bin/
if [ -f /usr/bin/cnchi-start.sh ]; then
rm -f /usr/bin/cnchi-start.sh
fi
wget https://gitlab.com/RebornOS/RebornOS/raw/master/airootfs/usr/bin/cnchi-start.sh
chmod +x /usr/bin/cnchi-start.sh
cd /
cd /usr/share/applications/
if [ -f /usr/share/applications/cnchi.desktop ]; then
rm -f /usr/share/applications/cnchi.desktop
fi
if [ -f /usr/share/applications/antergos-install.desktop ]; then
rm -f /usr/share/applications/antergos-install.desktop
fi
cp /usr/share/cnchi/RebornOS/airootfs/usr/share/applications/antergos-install.desktop /usr/share/applications/
echo "DONE"
}

# Download Reborn's normal Cnchi files instead
DOWNLOAD_SIMPLE(){
echo
echo
echo "Fabulous! Playing it safe I see :)"
echo "Well, have fun and happy hacking."
echo
echo "DOWNLOADING SPECIAL REBORN FILES FOR CNCHI (NOT EXPERIMENTAL)..."
echo
echo
cd /
cd /usr/share/cnchi/
mkdir $REBORN
cd $REBORN/
git clone https://gitlab.com/RebornOS/RebornOS.git --recursive
mv $REBORN/RebornOS/Cnchi $REBORN/Cnchi
mv $REBORN/RebornOS/images $REBORN/images
cd /
cd /usr/bin/
if [ -f /usr/bin/cnchi-start.sh ]; then
rm -f /usr/bin/cnchi-start.sh
fi
wget https://gitlab.com/RebornOS/RebornOS/raw/master/airootfs/usr/bin/cnchi-start.sh
chmod +x /usr/bin/cnchi-start.sh
cd /
cd /usr/share/applications/
if [ -f /usr/share/applications/cnchi.desktop ]; then
rm -f /usr/share/applications/cnchi.desktop
fi
if [ -f /usr/share/applications/antergos-install.desktop ]; then
rm -f /usr/share/applications/antergos-install.desktop
fi
cp $REBORN/RebornOS/airootfs/usr/share/applications/antergos-install.desktop /usr/share/applications/
echo "DONE"
}

# Customize Cnchi for Reborn OS
CUSTOMIZE(){
echo
echo
echo "MOVING DOWNLOADED FILES OVER..."
echo
echo
rm /usr/share/cnchi/data/packages.xml
cp $REBORN/Cnchi/packages.xml /usr/share/cnchi/data/
rm /usr/share/cnchi/data/pacman.tmpl
cp $REBORN/Cnchi/pacman.tmpl /usr/share/cnchi/data/
rm /usr/share/cnchi/src/features_info.py
cp $REBORN/Cnchi/features_info.py /usr/share/cnchi/src/
rm /usr/share/cnchi/src/pages/features.py
cp $REBORN/Cnchi/features.py /usr/share/cnchi/src/pages/
rm /usr/share/cnchi/src/desktop_info.py
cp $REBORN/Cnchi/desktop_info.py /usr/share/cnchi/src/
#rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/encfs.py
#cp ${script_path}/Cnchi/encfs.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/
rm /usr/share/cnchi/src/installation/boot/grub2.py
cp $REBORN/Cnchi/grub2.py /usr/share/cnchi/src/installation/boot/
rm /usr/share/cnchi/scripts/10_antergos
cp $REBORN/Cnchi/10_antergos /usr/share/cnchi/scripts/
rm /usr/share/cnchi/src/installation/boot/systemd_boot.py
cp $REBORN/Cnchi/systemd_boot.py /usr/share/cnchi/src/installation/boot/
rm /usr/share/cnchi/scripts/postinstall.sh
cp $REBORN/Cnchi/postinstall.sh /usr/share/cnchi/scripts/
chmod +x /usr/share/cnchi/scripts/postinstall.sh
#rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/main_window.py
rm /usr/share/cnchi/src/info.py
cp $REBORN/Cnchi/info.py /usr/share/cnchi/src/
#cp ${script_path}/Cnchi/main_window.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/
rm /usr/share/cnchi/src/show_message.py
cp $REBORN/Cnchi/show_message.py /usr/share/cnchi/src/
rm /usr/share/cnchi/src/pages/slides.py
cp $REBORN/Cnchi/slides.py /usr/share/cnchi/src/pages/
#rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/timezone.py
#cp ${script_path}/Cnchi/timezone.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/
rm /usr/share/cnchi/src/pages/welcome.py
cp $REBORN/Cnchi/welcome.py /usr/share/cnchi/src/pages/
#rm ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/desktop.py
#cp ${script_path}/Cnchi/desktop.py ${work_dir}/${arch}/airootfs/usr/share/cnchi/src/pages/
rm /usr/share/cnchi/src/download/metalink.py
cp $REBORN/Cnchi/metalink.py /usr/share/cnchi/src/download/
rm /usr/share/cnchi/src/pacman/pac.py
cp $REBORN/Cnchi/pac.py /usr/share/cnchi/src/pacman/
rm /usr/share/cnchi/data/images/antergos/antergos-logo-mini2.png
cp $REBORN/Cnchi/antergos-logo-mini2.png /usr/share/cnchi/data/images/antergos/
cp $REBORN/Cnchi/20-intel.conf /usr/share/cnchi/
cp $REBORN/Cnchi/lightdm-webkit2-greeter.conf /usr/share/cnchi/
rm /usr/share/cnchi/data/images/slides/1.png
cp $REBORN/Cnchi/1.png /usr/share/cnchi/data/images/slides/
rm /usr/share/cnchi/data/images/slides/2.png
cp $REBORN/Cnchi/2.png /usr/share/cnchi/data/images/slides/
rm /usr/share/cnchi/data/images/slides/3.png
cp $REBORN/Cnchi/3.png /usr/share/cnchi/data/images/slides/
cp $REBORN/Cnchi/sddm.conf /usr/share/cnchi/
rm /usr/share/pixmaps/cnchi.png
cp $REBORN/Cnchi/cnchi.png /usr/share/pixmaps/
rm /usr/share/cnchi/data/images/antergos/antergos-icon.png
cp $REBORN/Cnchi/antergos-icon.png /usr/share/cnchi/data/images/antergos/antergos-icon.png
cp $REBORN/Cnchi/flatpak.sh /usr/share/cnchi/
cp $REBORN/Cnchi/pkcon.sh /usr/share/cnchi/
cp $REBORN/Cnchi/pkcon2.sh /usr/share/cnchi/
cp $REBORN/Cnchi/flatpak.desktop /usr/share/cnchi/
#cp ${script_path}/Cnchi/pacman2.conf ${work_dir}/${arch}/airootfs/usr/share/cnchi/
cp $REBORN/Cnchi/update.desktop /usr/share/cnchi/
cp $REBORN/images/pantheon.png /usr/share/cnchi/data/images/desktops/
rm /usr/share/cnchi/data/images/desktops/deepin.png
rm /usr/share/cnchi/data/images/desktops/kde.png
rm /usr/share/cnchi/data/images/desktops/lxqt.png
rm /usr/share/cnchi/data/images/desktops/openbox.png
rm /usr/share/cnchi/data/images/desktops/xfce.png
cp $REBORN/images/apricity.png /usr/share/cnchi/data/images/desktops/
cp $REBORN/images/deepin.png /usr/share/cnchi/data/images/desktops/
cp $REBORN/images/cinnamon.png /usr/share/cnchi/data/images/desktops/
cp $REBORN/images/windows.png /usr/share/cnchi/data/images/desktops/
cp $REBORN/images/kde.png /usr/share/cnchi/data/images/desktops/
cp $REBORN/images/lxqt.png /usr/share/cnchi/data/images/desktops/
cp $REBORN/images/enlightenment.png /usr/share/cnchi/data/images/desktops/
cp $REBORN/images/xfce.png /usr/share/cnchi/data/images/desktops/
cp $REBORN/images/desktop-environment-apricity.svg /usr/share/cnchi/data/icons/scalable/
cp $REBORN/images/desktop-environment-pantheon.svg /usr/share/cnchi/data/icons/scalable/
cp $REBORN/images/desktop-environment-windows.svg /usr/share/cnchi/data/icons/scalable/
cp $REBORN/images/desktop-environment-budgie.svg /usr/share/cnchi/data/icons/scalable/
cp $REBORN/images/desktop-environment-i3.svg /usr/share/cnchi/data/icons/scalable/
cp $REBORN/Cnchi/reborn-mirrorlist /etc/pacman.d/
cp $REBORN/Cnchi/deepin-fix.sh /usr/share/cnchi/
cp $REBORN/Cnchi/deepin-fix.service /usr/share/cnchi/
echo "DONE"
echo
echo "Replacing Antergos mentions with Reborn"
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/advanced.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/alongside.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/ask.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/automatic.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/check.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/gtkbasebox.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/keymap.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/language.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/location.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/slides.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/summary.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/timezone.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/user_info.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/wireless.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/zfs.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/pages/desktop.py
sed -i "s/gnome/deepin/g" /usr/share/cnchi/src/pages/desktop.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/encfs.py
sed -i "s/Antergos/Reborn/g" /usr/share/cnchi/src/main_window.py
echo "DONE"
}

RUN(){
echo
echo
echo "YAY! Thankyou for your help in maintaining Reborn."
echo "We surely need it! So have fun, and feel free to"
echo "message me (Keegan) anytime you want. Got questions?"
echo "Just ask! Thanks, and good luck."
echo
echo
echo
REMOVE
INSTALL
ASK
CUSTOMIZE
}

export -f QUESTION DOWNLOAD_SIMPLE DOWNLOAD_EXPERIMENTAL ASK CUSTOMIZE INSTALL REMOVE RUN

QUESTION
