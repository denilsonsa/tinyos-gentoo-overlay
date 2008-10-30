# Copyright 1999-2008 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header$
# adapted from dev-embedded/avr-libc

ECVS_SERVER="mspgcc.cvs.sourceforge.net:/cvsroot/mspgcc"
ECVS_MODULE="jtag"

inherit cvs eutils toolchain-funcs

IUSE="nls"
MAKEOPTS="-j1" # parallel make breaks compiling ...

DESCRIPTION="JTAG access library for the MSP430 microcontroller architecture"
HOMEPAGE="http://mspgcc.sourceforge.net/"
S=${WORKDIR}/${ECVS_MODULE}

DESTTREE="/opt"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND="cross-msp430/mspgcc
		cross-msp430/msp430-libc"

src_unpack() {
	cvs_src_unpack
	cd "${S}"
	epatch ${FILESDIR}/${PV}-mk.patch
	epatch ${FILESDIR}/${PV}-lockFlashA.patch
	epatch ${FILESDIR}/${PV}-eraseFlashSegment.patch

}

src_compile() {
	emake || die
}

src_install() {
	dodir ${DESTTREE}/lib
	dodir ${DESTTREE}/bin
	insinto ${DESTTREE}/lib
	dolib hardware_access/libHIL.so
	dolib msp430/libMSP430mspgcc.so
	dolib.a msp430/libMSP430mspgcc.a
	insinto ${DESTTREE}/bin
	doins ${FILESDIR}/msp430-jtag
	ldconfig
}


#postinst(){
#	einfo "in order to use the usb MSP-FET430UIF you will need your kernel built with CONFIG_USB_SERIAL_TI=m"
#	einfo "mor info can be found on http://people.inf.ethz.ch/muellren/jtagmsp430.html"
#}

