# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

ETYPE="gcc-compiler"

# no support for SSP PIE this is a microcontroller after all ;)
SSP_UNSUPPORTED="msp430"
SSP_UCLIBC_UNSUPPORTED="${SSP_UNSUPPORTED}"
PIE_UCLIBC_UNSUPPORTED="msp430"
PIE_GLIBC_UNSUPPORTED="msp430"
SPLIT_SPECS=no

CTARGET=msp430

inherit toolchain eutils

DESCRIPTION="The GNU Compiler Collection. For msp430 "

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="|| ( >=sys-devel/gcc-config-1.3.12-r4 app-admin/eselect-compiler )
	>=sys-libs/zlib-1.1.4
	elibc_glibc? ( >=sys-libs/glibc-2.3.2-r9 )
	>=sys-devel/binutils-2.14.90.0.6-r1
	>=sys-devel/bison-1.875
	sparc? ( hardened? ( >=sys-libs/glibc-2.3.3.20040420 ) )
	!build? (
		gcj? (
			gtk? (
				|| ( ( x11-libs/libXt x11-libs/libX11 x11-libs/libXtst x11-proto/xproto x11-proto/xextproto ) virtual/x11 )
				>=x11-libs/gtk+-2.2
			)
			>=media-libs/libart_lgpl-2.1
		)
		>=sys-libs/ncurses-5.2-r2
		nls? ( sys-devel/gettext )
	)"

if [[ ${CATEGORY/cross-} != ${CATEGORY} ]]; then
	RDEPEND="${RDEPEND} ${CATEGORY}/binutils"
fi 
DEPEND="${RDEPEND}
	>=sys-apps/texinfo-4.2-r4
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"
PDEPEND="|| ( sys-devel/gcc-config app-admin/eselect-compiler )"


src_unpack() {

# 	if [[ ${CATEGORY/cross-} == ${CATEGORY} ]]; then
# 		eerror "this ebuild is ment to be use with crossdev, to build a toolchain for msp430 use :"
# 		eerror "emerge crossdev"
# 		eerror "crossdev -t msp430"
# 	fi
	if [[ -h /usr/msp430/lib/msp2/ldscripts ]] ; then 
		eerror "this ebuild is a bit broken ... "
		eerror "you need to fix some symlinks please use msp430-binutilsroot-fix.sh, and restart emrge  "
	fi

	gcc_src_unpack
	local PATCHESDIR=${FILESDIR}/${PV}
	
	# Those are patches from sys-devel/gcc-3.2.3-r4
	epatch ${PATCHESDIR}/gcc31-loop-load-final-value.patch
	epatch ${PATCHESDIR}/gcc32-strip-dotdot.patch
	epatch ${PATCHESDIR}/gcc32-athlon-alignment.patch
	epatch ${PATCHESDIR}/gcc32-c++-classfn-member-template.patch
	epatch ${PATCHESDIR}/gcc32-mklibgcc-serialize-crtfiles.patch

	# msp430 support 
	epatch ${PATCHESDIR}/gcc323-msp430.patch
}
