#!/bin/bash

set -eu

LATEST=${LATEST:-$(curl -sL https://www.kernel.org/finger_banner | awk '/^The latest stable / { print $NF }')}
MAJOR_MINOR="$(echo ${LATEST} | awk -v FS=. '{ printf "%d.%d", $1, $2 }')"
BASEURL=${BASEURL:-"https://cdn.kernel.org/pub/linux/kernel/"}
WORKDIR=/usr/src
KERNEL_DIR=${WORKDIR}/linux-${LATEST}
PKG_BUILD=${PKG_BUILD:-1}
PKG_NAME=${PKG_NAME:-kvm}
PKG_ARCH=${PKG_ARCH:-amd64}
PKG_REVISION=${PKG_REVISION:-1.0}

function _get_kernel_source() {
	ARCFILE=${WORKDIR}/linux-${LATEST}.tar.xz
	curl "${BASEURL}/${URL_PATH}/linux-${LATEST}.tar.xz" -o "${ARCFILE}"
	tar -xJf "${ARCFILE}" -C "${WORKDIR}"
}

function setup() {
	_get_kernel_source
	cp -v "${WORKDIR}/config-${MAJOR_MINOR}" "${KERNEL_DIR}/.config"
	cd "${KERNEL_DIR}"
	make olddefconfig
}

function _exec_make_kpkg() {
	time make-kpkg --append-to-version "-${PKG_BUILD}-${PKG_NAME}-${PKG_ARCH}" --revision "${PKG_REVISION}" \
			--initrd --rootcmd fakeroot --jobs "$(nproc)" $@
}

function build() {
	setup
	cd "${KERNEL_DIR}"
	_exec_make_kpkg kernel_image modules_image
	_exec_make_kpkg kernel_headers
}

case "${LATEST}" in
	*rc*)
		KERNEL_VERSION=${LATEST}
		URL_PATH=v4.x/testing
		;;
	4.[0-9]*.[0-9]*)
		KERNEL_VERSION=${LATEST}
		URL_PATH=v4.x
		;;
	4.[0-9]*)
		KERNEL_VERSION=${LATEST}.0
		URL_PATH=v4.x
		;;
	*)
		echo >&2 "${LATEST} is unsupportd kernel version."
		exit 4
		;;
esac

case "${1}" in
	build)
		build
		;;
	*)
		exit 3
esac
