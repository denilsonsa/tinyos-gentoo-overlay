# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit java-pkg-2
At="${PN}.zip"
S="${WORKDIR}/${PN}"

DESCRIPTION="A javaTM swing look and feel with theme, animation, sound, and alpha channel support"
SRC_URI="mirror://sourceforge/oalnf/${At}"
LICENSE="Apache-1.1"
HOMEPAGE="http://sourceforge.net/projects/oalnf"
KEYWORDS="amd64 ~x86"
SLOT="0"
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"
IUSE=""

src_install() {
	java-pkg_dojar oalnf.jar
}
