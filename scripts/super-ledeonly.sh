#!/bin/bash
#=================================================
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# Add luci-app-passwall
mkdir passwall passwall-packages passwall2
git clone https://github.com/xiaorouji/openwrt-passwall passwall
git clone https://github.com/xiaorouji/openwrt-passwall2 passwall2
git clone https://github.com/super27036/openwrt-passwall-packages passwall-packages

# Add luci-app-vssr <M>
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr

# Add OpenClash
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash

# Add luci-theme
git clone https://github.com/DHDAXCW/theme

rm -rf ../../customfeeds/luci/themes/luci-theme-argon
rm -rf ../../customfeeds/luci/themes/luci-theme-argon-mod
rm -rf ../../customfeeds/luci/applications/luci-app-argon-config

git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config

# Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# Add luci-app-smartdns & smartdns
svn export https://github.com/281677160/openwrt-package/trunk/luci-app-smartdns

# Add luci-aliyundrive-webdav
rm -rf ../../customfeeds/luci/applications/luci-app-aliyundrive-webdav
rm -rf ../../customfeeds/packages/multimedia/aliyundrive-webdav
svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav
svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav
popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
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
