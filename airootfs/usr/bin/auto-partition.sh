#!/bin/bash
# REQUIREMENTS: Must have only 1 free, unformatted partition on /dev/sda, that also happens to be at least 30 GB in size.
START()
{
if [[ $(parted /dev/sda unit B print free | grep 'Free Space' | awk '{print $4}' | wc -c) -le 14 ]]; then
        echo "ERROR - no unformatted partitions to use"
        echo "[ERROR] No unformatted partitions to use" >>/tmp/cnchi.log

elif [[ $(parted /dev/sda unit B print free | grep 'Free Space' | awk '{print $4}' | wc -c) -ge 16 ]]; then
        echo "ERROR - too many unformatted partition to use (must be only 1)"
        echo "[ERROR] Too many unformatted partitions to use (must only be 1)" >>/tmp/cnchi.log

else
        echo "[SUCCESS]  An unformatted partition exists. Continuing to auto-partition it for you..." >>/tmp/cnchi.log
        echo $(parted /dev/sda unit B print free | grep 'Free Space' | awk '{print $3}' | tr -d B) | awk  '{print $2}' >/partition.txt
       echo $(sed '2q;d' /partition.txt)
export SIZE=$(sed '2q;d' /partition.txt)
TEST
fi

if [[ $(parted /dev/sda unit B print free | grep 'Free Space' | awk '{print $4}' | wc -c) -le 4 ]]; then
        echo "Confirmed - no unformatted partitions to use"
        echo "[ERROR] No unformatted partitions to use" >>/tmp/cnchi.log

elif [[ $(parted /dev/sda unit B print free | grep 'Free Space' | awk '{print $4}' | wc -c) -ge 6 ]]; then
        echo "Confirmed - too many unformatted partition to use (must be only 1)"
        echo "[ERROR] Too many unformatted partitions to use (must only be 1)" >>/tmp/cnchi.log

else
        echo "SUCCESS - never mind! Found an unformatted partition to use."
        echo "[SUCCESS]  An unformatted partition exists. Continuing to auto-partition it for you..." >>/tmp/cnchi.log
        echo $(parted /dev/sda unit B print free | grep 'Free Space' | awk '{print $3}' | tr -d B) | awk  '{print $2}' >/partition.txt
       echo $(sed '1q;d' /partition.txt)
export SIZE=$(sed '1q;d' /partition.txt)
TEST
fi
}

TEST(){
if [[ $(parted /dev/sda unit B print free | grep 'Free Space' | awk '{print $4}' | wc -c) -eq 15 ]]; then
export SIZE=$(sed '2q;d' /partition.txt)
fi 
if [[ $(parted /dev/sda unit B print free | grep 'Free Space' | awk '{print $4}' | wc -c) -eq 5 ]]; then
export SIZE=$(sed '1q;d' /partition.txt)
fi
if [ "$SIZE" -ge 30000000000 ]; then
    echo "[SUCCESS] Partition is large enough to continue" >>/tmp/cnchi.log 
    FIRMWARE
else
    echo "[ERROR] Partition is too small to continue" >>/tmp/cnchi.log
fi
}

FIRMWARE(){
if [ -f "/sys/firmware/efi" ]; then
echo "[INFO] UEFI system detected" >>/tmp/cnchi.log
SIZES_UEFI
else
echo "[INFO] BIOS system detected" >>/tmp/cnchi.log
SIZES_BIOS
fi
}

SIZES_UEFI(){
export SIZE=$(sed '1q;d' /partition.txt)
# Root = 36%
echo $(awk -vn=$SIZE 'BEGIN{print(n*0.35)}') >>/tmp/rooting.txt
export ROOT=$(sed '1q;d' /tmp/rooting.txt) 
echo "[INFO] Root partition will be $ROOT bytes large" >>/tmp/cnchi.log
# Home = 64%
echo $(awk -vn=$SIZE 'BEGIN{print(n*0.63)}') >>/tmp/homing.txt
export HOME=$(sed '1q;d' /tmp/homing.txt) 
echo "[INFO] Home partition will be $HOME bytes large" >>/tmp/cnchi.log
# Swap = 1%
echo $(awk -vn=$SIZE 'BEGIN{print(n*0.01)}') >>/tmp/swapping.txt
export SWAP=$(sed '1q;d' /tmp/swapping.txt) 
echo "[INFO] Swap partition will be $SWAP bytes large" >>/tmp/cnchi.log
#export SWAP=512M
#echo "[INFO] SWAP file $SWAP large will be created" >>/tmp/cnchi.log
# Boot partition
echo $(df -h --output=source,fstype,size,used,avail,pcent,target -x tmpfs -x devtmpfs | grep "/dev/sd" | grep "/boot/efi") >/partitioning.txt
export BOOT=echo $(sed '1q;d' /partitioning.txt) | awk '{print $1}'
echo "[INFO] Boot partition to be used is $BOOT" >>/tmp/cnchi.log
PARTITION_ROOT
}

SIZES_BIOS(){
export SIZE=$(sed '1q;d' /partition.txt)
# Root = 36%
echo $(awk -vn=$SIZE 'BEGIN{print(n*0.35)}') >>/tmp/rooting.txt
export ROOT=$(sed '1q;d' /tmp/rooting.txt) 
echo "[INFO] Root partition will be $ROOT bytes large" >>/tmp/cnchi.log
# Home = 63%
echo $(awk -vn=$SIZE 'BEGIN{print(n*0.63)}') >>/tmp/homing.txt
export HOME=$(sed '1q;d' /tmp/homing.txt) 
echo "[INFO] Home partition will be $HOME bytes large" >>/tmp/cnchi.log
# Swap = 1%
echo $(awk -vn=$SIZE 'BEGIN{print(n*0.01)}') >>/tmp/swapping.txt
export SWAP=$(sed '1q;d' /tmp/swapping.txt) 
echo "[INFO] Swap partition will be $SWAP bytes large" >>/tmp/cnchi.log
# Boot = 1%
echo $(awk -vn=$SIZE 'BEGIN{print(n*0.01)}') >>/tmp/booting.txt
export SWAP=$(sed '1q;d' /tmp/booting.txt) 
echo "[INFO] Boot partition will be $BOOT bytes large" >>/tmp/cnchi.log
#export SWAP=512M
#echo "[INFO] SWAP file $SWAP large will be created" >>/tmp/cnchi.log
PARTITION_ROOT
}

PARTITION_ROOT(){
export ROOT=$(sed '1q;d' /tmp/rooting.txt) 
echo "[INFO] Root partition is being created..." >>/tmp/cnchi.log
export ROOT_START=echo $(parted /dev/sda unit B print free | grep 'Free Space' | tr -d B) | awk '{print $6}' 
export ROOT_END=echo $(parted /dev/sda unit B print free | grep 'Free Space' | tr -d B) | awk '{print $7}'
export ROOT_SIZE=$((ROOT_START+ROOT))
unit B mkpartfs primary ext4 $ROOT_START $ROOT_SIZE
# Determine what partition was just created
echo $(fdisk -l --bytes | grep $ROOT_SIZE) | awk '{print $1}' >/root.txt
export ROOT_PARTITION=$(sed '1q;d' /root.txt)
e2label $ROOT_PARTITION "ROOT"
echo "$ROOT_PARTITION / ext4 defaults,relatime,data=ordered 0 1" >>/etc/fstab
echo "[SUCCESS] Root partition has been created as $ROOT_PARTITION" >>/tmp/cnchi.log
PARTITION_HOME
}

PARTITION_HOME(){
export HOME=$(sed '1q;d' /tmp/homing.txt) 
echo "[INFO] Home partition is being created..." >>/tmp/cnchi.log
export HOME_START=echo $(parted /dev/sda unit B print free | grep 'Free Space' | tr -d B) | awk '{print $6}' 
export HOME_END=echo $(parted /dev/sda unit B print free | grep 'Free Space' | tr -d B) | awk '{print $7}'
export HOME_SIZE=$((HOME_START+HOME))
unit B mkpartfs primary ext4 $HOME_START $HOME_SIZE
# Determine what partition was just created
echo $(fdisk -l --bytes | grep $HOME_SIZE) | awk '{print $1}' >/home.txt
export HOME_PARTITION=$(sed '1q;d' /home.txt)
e2label $HOME_PARTITION "HOME"
echo "$HOME_PARTITION /home ext4 defaults,relatime,data=ordered 0 0" >>/etc/fstab
echo "[SUCCESS] Home partition has been created as $HOME_PARTITION" >>/tmp/cnchi.log
PARTITION_SWAP
}

PARTITION_SWAP(){
export SWAP=$(sed '1q;d' /tmp/swapping.txt) 
echo "[INFO] Swap partition is being created..." >>/tmp/cnchi.log
export SWAP_START=echo $(parted /dev/sda unit B print free | grep 'Free Space' | tr -d B) | awk '{print $6}' 
export SWAP_END=echo $(parted /dev/sda unit B print free | grep 'Free Space' | tr -d B) | awk '{print $7}'
export SWAP_SIZE=$((SWAP_START+SWAP))
unit B mkpartfs primary swap $SWAP_START $SWAP_SIZE
# Determine what partition was just created
echo $(fdisk -l --bytes | grep $SWAP_SIZE) | awk '{print $1}' >/swap.txt
export SWAP_PARTITION=$(sed '1q;d' /swap.txt)
e2label $SWAP_PARTITION "swap"
echo "$SWAP_PARTITION swap swap defaults 0 0" >>/etc/fstab
echo "[SUCCESS] Swap partition has been created as $HOME_PARTITION" >>/tmp/cnchi.log
swapon $SWAP_PARTITION
PARTITION_UEFI_BIOS
}

PARTITION_UEFI_BIOS(){
if [ -f "/sys/firmware/efi" ]; then
echo $(fdisk -l --bytes | grep EFI) | awk '{print $1}' >/esp.txt
export ESP_PARTITION=$(sed '1q;d' /esp.txt)
echo "$ESP_PARTITION /boot/efi vfat defaults,relatime 0 0" >>/etc/fstab
echo "[SUCCESS] Boot (EFI) partition has been created as $ESP_PARTITION" >>/tmp/cnchi.log
else
echo "[INFO] Boot partition is being created..." >>/tmp/cnchi.log
export BOOT=$(sed '1q;d' /tmp/booting.txt) 
export BOOT_START=echo $(parted /dev/sda unit B print free | grep 'Free Space' | tr -d B) | awk '{print $6}' 
export BOOT_END=echo $(parted /dev/sda unit B print free | grep 'Free Space' | tr -d B) | awk '{print $7}'
export BOOT_SIZE=$((HOME_START+HOME))
unit B mkpartfs primary ext4 $BOOT_START $BOOT_SIZE
# Determine what partition was just created
echo $(fdisk -l --bytes | grep $BOOT_SIZE) | awk '{print $1}' >/boot.txt
export HOME_PARTITION=$(sed '1q;d' /boot.txt)
e2label $BOOT_PARTITION "BOOT"
echo "$BOOT_PARTITION /boot ext4 defaults,relatime,data=ordered 0 0" >>/etc/fstab
echo "[SUCCESS] Boot partition has been created as $BOOT_PARTITION" >>/tmp/cnchi.log
fi
CLEAN
}

CLEAN(){
rm -f /partition.txt
rm -f /partitioning.txt
rm -f /root.txt
rm -f /home.txt
rm -f /swap.txt
rm -f /tmp/rooting.txt
rm -f /tmp/homing.txt
rm -f /tmp/swapping.txt
if [ -f "/sys/firmware/efi" ]; then
rm -f /esp.txt
else
rm -f /boot.txt
rm -f /tmp/booting.txt
fi
}
export -f START TEST FIRMWARE SIZES_BIOS SIZES_UEFI PARTITION_ROOT PARTITION_HOME PARTITION_SWAP PARTITION_UEFI_BIOS CLEAN
START
