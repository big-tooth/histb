cd ${WORK_PATH}
if [ "$ARCH" = "arm64" ]; then
    models="mv200 mv300"
    is64="-64"
else
    models="mv100 mv200 mv300"
    is64=""
fi

mkdir -p ${ROOTFS}/var/lib/bootargs
for model in $models;do
    cp -a package_files/bootargs/bootargs7-${model}${is64}.bin ${ROOTFS}/var/lib/bootargs/
    cp -a package_files/bootargs/emmc_bootargs-${model}${is64}.txt ${ROOTFS}/var/lib/bootargs/bootargs_input-${model}${is64}.txt
    chmod 777 ${ROOTFS}/var/lib/bootargs/bootargs_input-${model}${is64}.txt
done

cp -a package_files/bootargs/recoverbackup_${ARCH} ${ROOTFS}/usr/bin/recoverbackup
cp -a package_files/bootargs/checkone_${ARCH} ${ROOTFS}/usr/bin/checkone
chmod 777 ${ROOTFS}/usr/bin/recoverbackup
chmod 755 ${ROOTFS}/usr/bin/checkone

cat << EOF | chroot ${ROOTFS}
/usr/bin/checkone
EOF
