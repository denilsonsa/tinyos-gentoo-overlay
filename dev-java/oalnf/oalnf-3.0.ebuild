# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"
inherit java-pkg

DESCRIPTION="oalnf"

LICENSE="Apache-1.1"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-1.1.15${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
RDEPEND=""
DEPEND=""

S=${WORKDIR}/${MY_P}-1.1.15${CVS_MONTH}${CVS_YEAR}cvs/tools/java/jars

src_compile() {
	einfo "no compile"
}

src_install() {
	java-pkg_dojar oalnf.jar
}

