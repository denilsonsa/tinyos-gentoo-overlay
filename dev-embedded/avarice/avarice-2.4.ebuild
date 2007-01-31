# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/avarice/avarice-2.3.ebuild,v 1.1 2005/09/08 01:56:38 vapier Exp $

inherit eutils

DESCRIPTION="Interface for GDB to Atmel AVR JTAGICE in circuit emulator"
HOMEPAGE="http://avarice.sourceforge.net/"
SRC_URI="mirror://sourceforge/avarice/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL doc/avrIceProtocol.txt doc/running.txt doc/todo.txt
}
