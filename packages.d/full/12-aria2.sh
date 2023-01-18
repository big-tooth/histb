# install aria2
install_package 00-nginx.sh

aria2_url="https://git.histb.com/P3TERX/Aria2-Pro-Core/releases/download/1.36.0_2021.08.22/aria2-1.36.0-static-linux-${ARCH}.tar.gz"
aria2_file=$(basename ${aria2_url})

aria2ng_url="https://git.histb.com/mayswind/AriaNg/releases/download/1.2.3/AriaNg-1.2.3.zip"
aria2ng_file=$(basename ${aria2ng_url})

if [ ! -f ${DOWNLOAD_PATH}/${aria2_file} ]; then
    wget_cmd ${aria2_url}
fi

if [ ! -f ${DOWNLOAD_PATH}/${aria2ng_file} ]; then
    wget_cmd ${aria2ng_url}
fi

cd ${WORK_PATH}
mkdir -p ${ROOTFS}/home/ubuntu/downloads ${WWW_PATH}/ariang ${ROOTFS}/usr/local/aria2
chown nobody:nogroup ${ROOTFS}/home/ubuntu/downloads
chmod -R 777 ${ROOTFS}/home/ubuntu/downloads
unzip -o -q ${DOWNLOAD_PATH}/${aria2ng_file} -d ${WWW_PATH}/ariang

tar -xvzf ${DOWNLOAD_PATH}/${aria2_file} -C ${ROOTFS}/usr/bin
chmod 755 ${ROOTFS}/usr/bin/aria2c
touch ${ROOTFS}/usr/local/aria2/aria2.session
chmod 777 ${ROOTFS}/usr/local/aria2/aria2.session
chmod 755 ${ROOTFS}/usr/local/bin/update-tracker.sh
chmod 644 ${ROOTFS}/etc/systemd/system/aria2c.service

cat << EOF | chroot ${ROOTFS}
systemctl enable aria2c.service
EOF
