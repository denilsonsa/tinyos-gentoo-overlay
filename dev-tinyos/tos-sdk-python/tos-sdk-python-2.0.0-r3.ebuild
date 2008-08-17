# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos/tos-1.1.15-r1.ebuild,v 1.2 2006/08/09 19:42:12 sanchan Exp $
inherit python


MY_PV=${PVR}
MY_P=tinyos-${MY_PV}
DOC_PV=${MY_PV}

DESCRIPTION="TinyOS python sdk "
HOMEPAGE="http://www.tinyos.net/"
# tinyos.net does not provides tar.gz files anymore
#SRC_URI="http://www.tinyos.net/dist-2.0.0/tinyos/source/${MY_P}.tar.gz"
SRC_URI="http://www.naurel.org/stuff/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="2"
KEYWORDS="~x86 ~amd64"
DEPEND=">=dev-tinyos/tos-2.0.0
		>=dev-tinyos/tinyos-2.0.0
		>=dev-tinyos/tinyos-tools-1.2.3"

# Required to do anything useful. Could not be a RDEPEND since portage
# try to emerge nesc before tos.


S=${WORKDIR}/${MY_P}
src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	einfo "nothing to compile"
}

src_install() {
	local TOSROOT=/usr/src/tinyos-2.x


	dodir ${TOSROOT}/support/sdk/
	insinto ${TOSROOT}/support/sdk/
	doins -r "${S}"/support/sdk/python/
	chown -R root:0 "${D}"
}

