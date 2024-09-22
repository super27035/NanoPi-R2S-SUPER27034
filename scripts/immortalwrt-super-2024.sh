#!/bin/bash
#=================================================
# System Required: Linux
# Version: 1.0
# License: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# Clone community packages to package/community
mkdir -p package/community
pushd package/community

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package
rm -rf ../../customfeeds/luci/applications/luci-app-kodexplorer
rm -rf openwrt-package/verysync
rm -rf openwrt-package/luci-app-verysync

# 删除旧的 luci-theme-argon 和 luci-theme-argon-mod 和 luci-app-argon-config
rm -rf ../../customfeeds/luci/themes/luci-theme-argon-mod
rm -rf ../../customfeeds/luci/themes/luci-theme-argon
rm -rf ../../customfeeds/luci/applications/luci-app-argon-config

# 克隆新的 luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon ../../customfeeds/luci/themes/luci-theme-argon

# 克隆新的 luci-app-argon-config
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-app-argon-config ../../customfeeds/luci/applications/luci-app-argon-config


# Add luci-app-passwall
git clone https://github.com/xiaorouji/openwrt-passwall passwall
git clone https://github.com/xiaorouji/openwrt-passwall2 passwall2
git clone https://github.com/xiaorouji/openwrt-passwall-packages passwall-packages

# Add luci-app-ssr-plus
git clone --depth=1 https://github.com/fw876/helloworld

# Add luci-app-vssr <M>
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/super27035/luci-app-vssr

# Add luci-proto-minieap
git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap

# Add OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash

# Add ddnsto & linkease
git clone --depth=1 --filter=blob:none --sparse https://github.com/linkease/nas-packages-luci.git
cd nas-packages-luci
git sparse-checkout set luci/luci-app-linkease

git clone --depth=1 --filter=blob:none --sparse https://github.com/linkease/nas-packages.git
cd nas-packages
git sparse-checkout set network/services/ddnsto

# Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# Add luci-app-poweroff
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff

# Add OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter

# Add luci-app-irqbalance
git clone --depth=1 --filter=blob:none --sparse https://github.com/QiuSimons/OpenWrt-Add.git
cd OpenWrt-Add
git sparse-checkout set luci-app-irqbalance
cd ..

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default hostname
sed -i 's/OpenWrt/SUPERouter/g' package/base-files/files/bin/config_generate

# Password change
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/$1$S2TRFyMU$E8fE0RRKR0jNadn3YLrSQ0:18690:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

# Disable IPv6
sed -i 's/def_bool y/def_bool n/g' config/Config-build.in

# Fix uboot problem
sed -i '/^UBOOT_TARGETS := rk3528-evb rk3588-evb/s/^/#/' package/boot/uboot-rk35xx/Makefile

# Fan control scripts
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
wget -P target/linux/rockchip/armv8/base-files/etc/init.d/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/etc/init.d/fa-rk3328-pwmfan
wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/usr/bin/start-rk3328-pwm-fan.sh

# Modify zzz-default-settings
sed -i "s/'%D %V %C'/'Built by SUPER($(date +%Y.%m.%d))@%D %V'/g" package/base-files/files/etc/openwrt_release
sed -i "/DISTRIB_REVISION/d" package/base-files/files/etc/openwrt_release
sed -i "/%D/a\ Built by SUPER($(date +%Y.%m.%d))" package/base-files/files/etc/banner
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate