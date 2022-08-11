# ota update scripts

ota_script="package_files/ota.sh"
cp $ota_script ${ROOTFS}/tmp/ota.sh
chmod a+x ${ROOTFS}/tmp/ota.sh

cat << EOF | chroot ${ROOTFS}
bash /tmp/ota.sh
EOF

rm -f ${ROOTFS}/tmp/ota.sh
