#!/bin/bash
source utils.sh

ARCH="armhf"

usage() {
    cat <<-EOF
Usage: usage: 1-init-img.sh [-64]
EOF
    _exit $1
}

while [ $# -gt 0 ]; do
    if [ -z "$1" ]; then
        usage 0
    else
        case "$1" in
            --help | -h)
                usage 0
                ;;
            -64)
                ARCH="arm64"
                shift
                ;;
            *)
                usage 1
                ;;
        esac
    fi
done

RELEASE="20.04.4"
IMG_FILE="ubuntu-base-${RELEASE}-base-${ARCH}.tar.gz"
IMG_URL="https://cdimage.ubuntu.com/ubuntu-base/releases/${RELEASE}/release"

mkdir -p downloads && cd downloads

if [ "$(get_sha256 -c ${IMG_URL}/SHA256SUMS ${IMG_FILE})" != "$(get_sha256 -l ${IMG_FILE})" ]
then
	wget --no-check-certificate ${IMG_URL}/${IMG_FILE} || _exit 1 "Failed to download ${IMG_FILE} ..."
fi

cd -
if [ ! -d rootfs ]
then
	mkdir -p rootfs
elif [ "$(ls -A rootfs)" ]
then
	rm -rf rootfs/*
fi
tar -zxvf downloads/${IMG_FILE} -C rootfs
echo -e "$RELEASE\n$ARCH" > target_arch
