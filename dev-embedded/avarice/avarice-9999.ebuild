# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/avarice/avarice-2.3.ebuild,v 1.1 2005/09/08 01:56:38 vapier Exp $

inherit eutils cvs

DESCRIPTION="Interface for GDB to Atmel AVR JTAGICE in circuit emulator"
HOMEPAGE="http://avarice.sourceforge.net/"
#SRC_URI="mirror://sourceforge/avarice/${P}.tar.bz2"
#SRC_URI="http://naurel.org/stuff/${P}.tar.bz2"

# cvs -z3 -d:pserver:anonymous@avarice.cvs.sourceforge.net:/cvsroot/avarice co -P modulename

ECVS_SERVER="avarice.cvs.sourceforge.net:/cvsroot/avarice"

ECVS_MODULE="avarice"
ECVS_AUTH="pserver"
ECVS_USER="anonymous"
ECVS_CLEAN="true"

S=${WORKDIR}/${ECVS_MODULE}



LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_unpack(){
	cvs_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/avarice-9999-gdb-avarice-script.patch"
	./Bootstrap
}

src_install() {

	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL doc/avrIceProtocol.txt doc/running.txt doc/todo.txt
}
