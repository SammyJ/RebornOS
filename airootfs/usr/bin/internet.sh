gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout '0' && gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout '0'
systemd-detect-virt
if [ "$?" != oracle ]; then
echo "Running in Virtualbox"
fi
#sed '54 c\
#> http://experiencing-reborn.weebly.com/welcome.html' /usr/share/cnchi/src/pages/slides.py
sudo pacman -Scc --noconfirm
sudo paccache -ruk0 
sudo paccache -r --keep 0
wget --spider www.google.com
if [ "$?" = 0 ]; then
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman -Syy
sudo pacman-key --init
sudo pacman-key --populate archlinux antergos aurarchlinux rebornos
sudo pacman-key --refresh-keys
sudo pacman -Syy
sudo reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
# if [ ! -z $(grep "eu" "etc/pacman.d/mirrorlist") ]; then 
# sudo cp /usr/bin/cnchi/pacman.conf /etc/
# sudo mv /usr/bin/cnchi/reborn-mirrorlist2 /etc/pacman.d/reborn-mirrorlist
# fi
else exec /usr/bin/internet.sh
fi
