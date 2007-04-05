# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header$
# adapted from dev-embedded/avr-libc
# adapted from http://www.informatik.uni-mannheim.de/pi4.data/content/projects/msp430/

inherit eutils

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
	unpack  ${A}
	cd "${S}"
# FIXME well it "works" ...
    sed -i 's/crt430x2001.o  crt430x2011.o/ /g' src/Makefile
    sed -i 's/crt430x2002.o  crt430x2012.o/ /g' src/Makefile
    sed -i 's/crt430x2003.o  crt430x2013.o/ /g' src/Makefile
    sed -i 's/crt430x2234.o//g' src/Makefile 
    sed -i 's/crt430x2254.o//g' src/Makefile 
    sed -i 's/crt430x2274.o//g' src/Makefile 
    sed -i 's/crt430xG4618.o//g' src/Makefile 
    sed -i 's/crt430xG4617.o//g' src/Makefile 
    sed -i 's/crt430xG4616.o//g' src/Makefile 
    sed -i 's/crt430xG4619.o//g' src/Makefile 

#    sed -i 's:prefix = /usr/local/msp430:prefix = '${D}'/opt/msp_2007_03_04/:' src/Makefile
    mkdir src/msp1
    mkdir src/msp2

}

src_compile() {

	cd ${WORKDIR}/${PN}-${PV}/src
	emake || die
}

src_install() {
	cd ${WORKDIR}/${PN}-${PV}/src
	einstall || die
}
