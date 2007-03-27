# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="MSP430 Cross Development Kit"

HOMEPAGE="http://cdk4msp.sourceforge.net/"

SRC_URI="mirror://sourceforge/cdk4msp/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"


src_compile() {
	econf \
		--sysconfdir=/etc \
		--prefix=/usr \
		--mandir=/usr/share/man \
		|| die "econf failed"
	
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS CHANGES MAINTAINERS
	fperms ogu+rX /opt/cdk4msp/msp430
}

pkg_postinst() {

	einfo "To use the msp430-commands source the file /etc/cdk4msp.sh in your
	~/.bashrc or similar."

}
