# others
cd ${WORK_PATH}

chmod 777 -R package_files/others/sbin

if [ -d package_files/others/sbin/common ]; then
	cp -a package_files/others/sbin/common/* ${ROOTFS}/sbin
fi
if [ -d package_files/others/sbin/${ARCH} ]; then
	cp -a package_files/others/sbin/${ARCH}/* ${ROOTFS}/sbin
fi

chmod 777 -R ${ROOTFS}/etc/profile.d
chmod 755 ${ROOTFS}/usr/bin/nasinfo
sed -i "s/ports.ubuntu.com/repo.huaweicloud.com/g" ${ROOTFS}/etc/apt/sources.list
echo "20220808-1" > ${ROOTFS}/etc/nasversion
