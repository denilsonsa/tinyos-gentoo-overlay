# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

DESCRIPTION="The TinyOS uisp, a tool for AVR which can interface to in-system programmers"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
DEPEND="!dev-embedded/uisp"
RDEPEND="!dev-embedded/uisp"

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools/src/uisp

src_compile() {
	dosed "s:AM_INIT_AUTOMAKE(uisp, 20050519tinyos):AM_INIT_AUTOMAKE(tos-uisp, ${PV}):" configure.in
	./bootstrap
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	INSTALL_MASK=/usr/share/doc/uisp-20050519tinyos
	emake DESTDIR="${D}" install || die "install failed"
	dodoc doc/* AUTHORS ChangeLog CHANGES TODO
}
