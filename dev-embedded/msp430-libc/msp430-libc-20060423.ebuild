# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header$
# adapted from dev-embedded/avr-libc
# adapted from http://www.informatik.uni-mannheim.de/pi4.data/content/projects/msp430/

CHOST="msp430"
CTARGET="msp430"

DESCRIPTION="Libc for the MSP430 microcontroller architecture"
HOMEPAGE="http://mspgcc.sourceforge.net/"
SRC_URI="http://naurel.org/stuff/${P}.tar.bz2"

SLOT="0"
# May need to clarify license 
# random look into source files headers gave :
# parts are BSD 
# parts are  (c) sun  "free use"
# parts are GPL
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND=">=sys-devel/crossdev-0.9.1"
[[ ${CATEGORY/cross-} != ${CATEGORY} ]] \
	&& RDEPEND="!dev-embedded/msp430-libc" \
	|| RDEPEND=""


pkg_setup() {
	ebegin "Checking for msp430-gcc"
	if type -p msp430-gcc > /dev/null ; then
		eend 0
	else
		eend 1

		eerror
		eerror "Failed to locate 'msp430-gcc' in \$PATH. You can install an MSP430 toolchain using:"
		eerror "  $ crossdev -t msp430"
		eerror
		die "MSP430 toolchain not found"
	fi
}

src_unpack() {
	src_unpack
	cd ${WORKDIR}
	epatch ${FILESDIR}/gcc-3.3-unsupported.patch
}

src_compile() {
	cd ${WORKDIR}/${PN}/src
	emake || die
}

src_install() {
	cd ${WORKDIR}/${PN}/src
	prefix="/usr/" einstall || die
}
