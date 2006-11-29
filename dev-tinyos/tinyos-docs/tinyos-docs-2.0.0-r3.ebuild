# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos/tos-1.1.15-r1.ebuild,v 1.2 2006/08/09 19:42:12 sanchan Exp $
inherit eutils


DESCRIPTION="TinyOS: an open-source OS designed for wireless embedded sensor networks"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.naurel.org/stuff/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND=""

PDEPEND=" dev-tinyos/nesc"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	einfo "FIXME, should compile the docs "
}

src_install() {
	dodoc ${PN}
}

pkg_postinst() {
	elog "If you want to use TinyOS on real hardware you need a cross compiler."
	elog "You should emerge sys-devel/crossdev and compile any toolchain you need"
	elog "Example: for Mica2 and Mica2 Dot: crossdev --target avr"
	ebeep 5
	epause 5
}

