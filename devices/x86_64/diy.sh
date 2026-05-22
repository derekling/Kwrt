#!/bin/bash

SHELL_FOLDER=$(dirname $(readlink -f "$0"))

#bash $SHELL_FOLDER/../common/kernel_6.6.sh

sed -i 's/Os/O2/g' include/target.mk || true

git_clone_path master https://github.com/coolsnowwolf/lede target/linux/x86/files target/linux/x86/patches-6.12

wget -N https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/x86/base-files/etc/board.d/02_network -P target/linux/x86/base-files/etc/board.d/ || true

sed -i 's/kmod-r8169/kmod-r8168/' target/linux/x86/image/64.mk || true

sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += kmod-fs-f2fs kmod-mmc kmod-sdhci kmod-usb-hid usbutils pciutils lm-sensors-detect kmod-atlantic kmod-vmxnet3 kmod-igbvf kmod-iavf kmod-bnx2x kmod-pcnet32 kmod-tulip kmod-r8101 kmod-r8125 kmod-r8126 kmod-8139cp kmod-8139too kmod-i40e kmod-drm-amdgpu kmod-mlx4-core kmod-mlx5-core fdisk lsblk kmod-phy-broadcom kmod-ixgbevf/' target/linux/x86/Makefile || true

sed -i 's/256/1024/g' target/linux/x86/image/Makefile || true

# 1. 修改后台IP（默认192.168.1.1）
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate || true

# 2. 修改主机名
sed -i 's/OpenWrt/KWRT-Router/g' package/base-files/files/bin/config_generate || true

# 3. 开启 Wi-Fi（x86_64 不需要，但保留命令容错）
[ -f package/kernel/mac80211/files/lib/wifi/mac80211.sh ] && \
  sed -i 's/disabled='\''1'\''/disabled='\''0'\''/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh || true

exit 0
