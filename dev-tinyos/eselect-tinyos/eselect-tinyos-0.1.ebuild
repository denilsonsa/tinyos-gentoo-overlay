# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

DESCRIPTION="Manages environement for tinyos"
HOMEPAGE="http://www.naurel.org/"

#SRC_URI="http://naurel.org/stuff/eselect-tinyos-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.2"

src_install() {
	insinto /usr/share/eselect/modules
	#cp ${WORKDIR}/eselect-tinyos-${PV} ${T}/tinyos.eselect
	cp "${FILESDIR}"/eselect-tinyos "${T}"/tinyos.eselect
	doins "${T}"/tinyos.eselect
}
