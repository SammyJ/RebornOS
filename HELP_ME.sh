#!/bin/bash
#####################################
# Script to make ISO testing easier #
#####################################

QUESTION(){
echo
echo "Please select your preferred course of action:"
echo
options=("Build an ISO" "Update code to latest stuff on Gitlab" "Change Branches" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Build an ISO")
            BUILD;break;;
        "Update code to latest stuff on Gitlab")
            UPDATE;break;;
        "Change Branches")
           BRANCHES;break;;
        "Quit")
            break
            ;;
        *) echo "ERROR!!! ERROR!!!! SOUND THE ALARM!!!" 
            echo "Sadly, option $REPLY is not possible! Please select either option 1, 2, or 3 instead. Thank you!";;
    esac
done
}

BRANCHES(){
touch /tmp/branch.txt
yad --form --separator='\n' \
    --field="Branch:cb" "master!testing!">/tmp/branch.txt \
MY_BRANCH=$(sed '1q;d' /tmp/branch.txt)
sudo git checkout $(sed '1q;d' /tmp/branch.txt)
echo
echo
echo "DONE"
rm -f /tmp/branch.txt
echo
echo
}

BUILD(){
echo "ENSURING ALL DEPENDENCIES ARE ALREADY INSTALLED..."
sudo pacman -S arch-install-scripts cpio dosfstools git libisoburn mkinitcpio-nfs-utils make patch squashfs-tools wget lynx archiso reflector-antergos --noconfirm --needed
echo
if [ -f ./work/pacman.conf ]; then
echo "REMOVING FILES FROM PREVIOUS BUILD..."
rm -rf ./work 
echo "WELL THAT TOOK AWHILE! BUT NOW WE'RE DONE :)"
fi
echo
echo 
echo "###################"
echo "# BUILDING ISO... #"
echo "###################"
echo
echo
./build.sh -v
}

UPDATE(){
if [ -f ./work/pacman.conf ]; then
echo
echo "CLEANING EVERYTHING FRIST FROM PREVIOUS BUILDS..."
rm -rf ./work 
echo
echo "WELL THAT TOOK AWHILE! BUT NOW WE'RE DONE :)"
fi
echo
echo
echo "UPDATING TO THE LATEST AND GREATEST..."
sudo git pull
echo
echo "DONE"
}

export -f QUESTION BUILD UPDATE BRANCHES
QUESTION
