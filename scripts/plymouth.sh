#!/bin/bash
echo $(lspci -v | grep -A10 VGA | grep driver | awk '{print $5}') >/tmp/plymouth.txt
DEVICE=$(sed '1q;d' /tmp/plymouth.txt)
#echo $(grep -n "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | grep -Eo '^[^:]+')s >/tmp/line.txt
#LINE1=$(sed '1q;d' /tmp/line.txt)
#SWAP_UUID=$(sudo blkid /dev/sd* | grep "swap" | awk '{print $2}' | sed 's/\"//g')
#echo $(cat /etc/mkinitcpio.conf | grep "keyboard keymap") >/tmp/hooks.txt
#HOOK=sed -n 's/.*base udev //p' /tmp/hooks.txt
#echo $(grep -n "keyboard keymap" /etc/mkinitcpio.conf | grep -Eo '^[^:]+')s >/tmp/line2.txt
#LINE2=$(sed '1q;d' /tmp/line2.txt)
#sed -i "$LINE2|.*|HOOKS=base udev plymouth $HOOK|" /etc/mkinitcpio.conf
# sed -i "$LINE1|.*|GRUB_CMDLINE_LINUX_DEFAULT=quiet splash resume=$SWAP_UUID|" /etc/default/grub
echo $(grep -n "MODULES=" /etc/mkinitcpio.conf | grep -Eo '^[^:]+')s | awk '{print $2}' >/tmp/line3.txt
LINE3=$(sed '1q;d' /tmp/line3.txt)
sed -i "$LINE3|.*|MODULES=\"$DEVICE\"|" /etc/mkinitcpio.conf
plymouth-set-default-theme -R arch-charge-big
mkinitcpio -p linux
grub-mkconfig -o /boot/grub/grub.cfg
rm -f /tmp/line.txt
rm -f /tmp/line2.txt
rm -f /tmp/plymouth.txt
rm -f /tmp/modules.txt
rm -f /tmp/hooks.txt
rm -f /etc/xdg/autostart/plymouth-reborn.desktop
