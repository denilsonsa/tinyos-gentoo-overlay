# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

DESCRIPTION="Manages environement for tinyos"
HOMEPAGE="http://www.naurel.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.2"

src_install() {
	insinto /usr/share/eselect/modules
	cp ${FILESDIR}/eselect-tinyos-0.2 ${T}/tinyos.eselect
	doins ${T}/tinyos.eselect
}
