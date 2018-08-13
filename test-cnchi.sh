#!/bin/bash
##############################
# Script to download and install Cnchi #
##############################


# Defining Variables
export CNCHI_GIT_BRANCH="0.14.426"
export CNCHI_GIT_URL="https://github.com/Antergos/Cnchi/archive/${CNCHI_GIT_BRANCH}.zip"
export script_path="/usr/share"

# Removing Cnchi files if they exist
echo "Removing all installed instances of Cnchi"
if [ -f /usr/share/cnchi/Readme.md ]; then
rm -rf /usr/share/cnchi
rm -f /usr/bin/cnchi
rm -f /usr/share/applications/cnchi.desktop
rm -f /usr/share/pixmaps/cnchi.png
fi
echo "DONE"
echo
echo "#########################################################"
echo "########## DOWNLOADING & INSTALLING CNCHI... ################"
echo "#########################################################"
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
