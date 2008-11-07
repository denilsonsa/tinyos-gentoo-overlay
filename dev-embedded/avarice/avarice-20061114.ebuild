# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/avarice/avarice-2.3.ebuild,v 1.1 2005/09/08 01:56:38 vapier Exp $

inherit eutils

DESCRIPTION="Interface for GDB to Atmel AVR JTAGICE in circuit emulator"
HOMEPAGE="http://avarice.sourceforge.net/"
#SRC_URI="mirror://sourceforge/avarice/${P}.tar.bz2"
SRC_URI="http://naurel.org/stuff/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_unpack(){
	unpack ${A}

# prevents the error : Reply contains invalid hex digit 79

	# alternatice to patch ....
#	echo "set remotetimeout 60"> ${P}/scripts/gdb-avarice-script-new
#	cat ${P}/scripts/gdb-avarice-script >> ${P}/scripts/gdb-avarice-script-new
#	mv ${P}/scripts/gdb-avarice-script-new ${P}/scripts/gdb-avarice-script
	epatch "${FILESDIR}/gdb-avarice-script.patch"
}


src_install() {

	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL doc/avrIceProtocol.txt doc/running.txt doc/todo.txt
}
