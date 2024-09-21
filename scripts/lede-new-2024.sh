#!/bin/bash
#=================================================
# System Required: Linux
# Version: 1.0
# License: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# Alist - 文件管理工具 (注释掉，可以根据需要取消注释)
# git clone https://github.com/sbwml/luci-app-alist package/alist
# 删除默认的 Go 语言包并替换为新的 Go 语言包
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang

# 创建社区包目录并进入该目录
mkdir package/community
pushd package/community

# 添加 Lienol 的软件包
git clone --depth=1 https://github.com/Lienol/openwrt-package
# 删除部分不需要的应用程序
rm -rf ../../customfeeds/luci/applications/luci-app-kodexplorer
rm -rf openwrt-package/verysync
rm -rf openwrt-package/luci-app-verysync

# 克隆 OpenWrt-Add 并只检出 luci-app-irqbalance
git clone --depth=1 --filter=blob:none --sparse https://github.com/QiuSimons/OpenWrt-Add.git
cd OpenWrt-Add
git sparse-checkout set luci-app-irqbalance

# 添加 Passwall
mkdir passwall passwall2 passwall-packages 
git clone https://github.com/xiaorouji/openwrt-passwall passwall
git clone https://github.com/xiaorouji/openwrt-passwall2 passwall2
git clone https://github.com/xiaorouji/openwrt-passwall-packages passwall-packages

# 添加 SSR-Plus
git clone --depth=1 https://github.com/fw876/helloworld

# 添加 VSSR (小飞机)
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/super27035/luci-app-vssr

# 添加 luci-proto-minieap (校园网协议)
git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap

# 添加 OpenClash (注释掉以防冲突，可以根据需要取消注释)
# git clone --depth=1 --filter=blob:none --sparse https://github.com/vernesong/OpenClash.git
# cd OpenClash
# git sparse-checkout set luci-app-openclash

# 直接克隆 OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash

# 添加 ddnsto & linkease
git clone --depth=1 --filter=blob:none --sparse https://github.com/linkease/nas-packages-luci.git
cd nas-packages-luci
git sparse-checkout set luci/luci-app-linkease

git clone --depth=1 --filter=blob:none --sparse https://github.com/linkease/nas-packages.git
cd nas-packages
git sparse-checkout set network/services/ddnsto

# 添加新的 Argon 主题及配置
mkdir luci-theme-argon luci-app-argon-config
git clone -b 18.06 https://github.com/super27035/luci-theme-argon luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config luci-app-argon-config

# 添加 subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# 添加 luci-app-poweroff
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff

# 添加 OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter

# 修改 mt76 无线驱动问题
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# 将默认 shell 改为 zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# 修改默认 IP 地址
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

# 修改默认主机名
sed -i 's/OpenWrt/SUPERouter/g' package/base-files/files/bin/config_generate

# 修改默认密码
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/$1$S2TRFyMU$E8fE0RRKR0jNadn3YLrSQ0:18690:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

# 禁用 IPv6
sed -i 's/def_bool y/def_bool n/g' config/Config-build.in

# 修复 U-Boot 问题
sed -i '/^UBOOT_TARGETS := rk3528-evb rk3588-evb/s/^/#/' package/boot/uboot-rk35xx/Makefile

# 启用风扇控制脚本
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
wget -P target/linux/rockchip/armv8/base-files/etc/init.d/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/etc/init.d/fa-rk3328-pwmfan
wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/usr/bin/start-rk3328-pwm-fan.sh

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
sed -i "s/${orig_version}/SUPER-LEDE ${orig_version} (${date_version})/g" zzz-default-settings
popd
