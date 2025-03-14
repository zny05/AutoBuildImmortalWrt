#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
echo "编译固件大小为: $PROFILE MB"
echo "Include Docker: $INCLUDE_DOCKER"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings
# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始编译..."



# 定义所需安装的包列表 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES -dnsmasq"
PACKAGES="$PACKAGES dnsmasq-full"
PACKAGES="$PACKAGES luci"
PACKAGES="$PACKAGES ca-bundle"
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-app-ttyd"
PACKAGES="$PACKAGES ddns-go"
PACKAGES="$PACKAGES luci-app-ddns-go"
PACKAGES="$PACKAGES minidlna"
PACKAGES="$PACKAGES luci-app-minidlna"
PACKAGES="$PACKAGES qbittorrent"
PACKAGES="$PACKAGES luci-app-qbittorrent"
PACKAGES="$PACKAGES transmission-daemon"
PACKAGES="$PACKAGES luci-app-transmission"
PACKAGES="$PACKAGES docker"
PACKAGES="$PACKAGES dockerd"
PACKAGES="$PACKAGES luci-app-dockerman"
PACKAGES="$PACKAGES luci-app-docker"
PACKAGES="$PACKAGES luci-i18n-docker-zh-cn"
PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
PACKAGES="$PACKAGES luci-lib-docker"
PACKAGES="$PACKAGES docker-compose"
PACKAGES="$PACKAGES luci-app-diskman"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-filebrowser-zh-cn"
PACKAGES="$PACKAGES luci-i18n-opkg-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-app-rustdesk-server"
PACKAGES="$PACKAGES luci-app-samba4"
PACKAGES="$PACKAGES rustdesk-server"
PACKAGES="$PACKAGES miniupnpd"
PACKAGES="$PACKAGES luci-app-upnp"
PACKAGES="$PACKAGES netdata"
PACKAGES="$PACKAGES luci-app-netdata"
PACKAGES="$PACKAGES ip-full"
PACKAGES="$PACKAGES kmod-tun"
PACKAGES="$PACKAGES kmod-inet-diag"
PACKAGES="$PACKAGES luci-i18n-netdata-zh-cn"
PACKAGES="$PACKAGES luci-i18n-base-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"

# 判断是否需要编译 Docker 插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    echo "Adding package: luci-i18n-dockerman-zh-cn"
fi

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE="generic" PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$PROFILE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
