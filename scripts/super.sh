#!/bin/bash
#=================================================
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# alist
# git clone https://github.com/sbwml/luci-app-alist package/alist
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package
rm -rf ../../customfeeds/luci/applications/luci-app-kodexplorer
rm -rf openwrt-package/verysync
rm -rf openwrt-package/luci-app-verysync

# Add luci-app-irqbalance by QiuSimons https://github.com/QiuSimons/OpenWrt-Add
# svn export https://github.com/QiuSimons/OpenWrt-Add/trunk/luci-app-irqbalance

git clone --depth=1 --filter=blob:none --sparse https://github.com/QiuSimons/OpenWrt-Add.git
cd OpenWrt-Add
git sparse-checkout set luci-app-irqbalance


# Add luci-app-passwall
mkdir passwall passwall2 passwall-packages 
git clone https://github.com/xiaorouji/openwrt-passwall passwall
git clone https://github.com/xiaorouji/openwrt-passwall2 passwall2
git clone https://github.com/xiaorouji/openwrt-passwall-packages passwall-packages

# git clone https://github.com/xiaorouji/openwrt-passwall
# git clone -b packages https://github.com/xiaorouji/openwrt-passwall
# git clone -b luci https://github.com/xiaorouji/openwrt-passwall
# svn export https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall

# Add luci-app-ssr-plus
git clone --depth=1 https://github.com/fw876/helloworld

# Add luci-app-unblockneteasemusic
# rm -rf ../../customfeeds/luci/applications/luci-app-unblockmusic
# git clone --branch master https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git

# Add luci-app-vssr <M>
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/super27035/luci-app-vssr

# Add luci-proto-minieap
git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap

# Add OpenClash
# git clone --depth=1 --filter=blob:none --sparse https://github.com/vernesong/OpenClash.git
# cd OpenClash
# git sparse-checkout set luci-app-openclash

# Add OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash

# Add ddnsto & linkease
# svn export https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto
# svn export https://github.com/linkease/nas-packages/trunk/network/services/ddnsto

# Add ddnsto & linkease
git clone --depth=1 --filter=blob:none --sparse https://github.com/linkease/nas-packages-luci.git
cd nas-packages-luci
git sparse-checkout set luci/luci-app-linkease

git clone --depth=1 --filter=blob:none --sparse https://github.com/linkease/nas-packages.git
cd nas-packages
git sparse-checkout set network/services/ddnsto


# Add luci-app-onliner (need luci-app-nlbwmon)
git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add luci-app-oled (R2S Only)
git clone --depth=1 https://github.com/NateLol/luci-app-oled

# Add ServerChan
git clone --depth=1 https://github.com/tty228/luci-app-serverchan

# Add luci-app-dockerman
rm -rf ../../customfeeds/luci/collections/luci-lib-docker
rm -rf ../../customfeeds/luci/applications/luci-app-docker
rm -rf ../../customfeeds/luci/applications/luci-app-dockerman
git clone --depth=1 https://github.com/lisaac/luci-app-dockerman
git clone --depth=1 https://github.com/lisaac/luci-lib-docker

# Add luci-theme
git clone https://github.com/DHDAXCW/theme
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config

# Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# Add luci-app-smartdns & smartdns
# svn export https://github.com/281677160/openwrt-package/trunk/luci-app-smartdns

# Add luci-app-services-wolplus
# svn export https://github.com/msylgj/OpenWrt_luci-app/trunk/luci-app-services-wolplus

# Add apk (Apk Packages Manager)
# svn export https://github.com/openwrt/packages/trunk/utils/apk

# Add luci-app-poweroff
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff

# Add OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter

# Add luci-aliyundrive-webdav
# rm -rf ../../customfeeds/luci/applications/luci-app-aliyundrive-webdav
# rm -rf ../../customfeeds/packages/multimedia/aliyundrive-webdav
# svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav
# svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav
# popd

# Add Pandownload
# pushd package/lean
# svn export https://github.com/immortalwrt/packages/trunk/net/pandownload-fake-server
# popd

# Mod zzz-default-settings
# pushd package/lean/default-settings/files
# sed -i '/http/d' zzz-default-settings
# sed -i '/18.06/d' zzz-default-settings
# export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
# export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
# sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
# popd

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd
# sed -i 's/5.15/5.10/g' target/linux/rockchip/Makefile
# Modify default IP
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate
# Modify default hosename
sed -i 's/OpenWrt/SUPERouter/g' package/base-files/files/bin/config_generate
# Password
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/$1$S2TRFyMU$E8fE0RRKR0jNadn3YLrSQ0:18690:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings
# Disable ipv6
sed -i 's/def_bool y/def_bool n/g' config/Config-build.in

#fix uboot problem
sed -i '/^UBOOT_TARGETS := rk3528-evb rk3588-evb/s/^/#/' package/boot/uboot-rk35xx/Makefile

# 风扇脚本
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
wget -P target/linux/rockchip/armv8/base-files/etc/init.d/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/etc/init.d/fa-rk3328-pwmfan
wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/usr/bin/start-rk3328-pwm-fan.sh
