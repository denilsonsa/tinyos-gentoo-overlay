# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils cvs java-pkg-2

ECVS_SERVER="samoa.cs.ucla.edu:/project/cvs/pub"

ECVS_MODULE="avrora"
ECVS_AUTH="pserver"
ECVS_USER="anonymous"
ECVS_CLEAN="true"

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="AVR simulation and analysis framework"
HOMEPAGE="http://compilers.cs.ucla.edu/avrora/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#IUSE=""
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

PATCHES="
${FILESDIR}/avrora_GDBServer_dont_exit_when_reading_uninitialized_mem.patch
"

src_compile() {

	emake avrora || die "emake failed"
	emake cck || die "emake failed"
	cd ${S}/bin/
	jar cmf MANIFEST.MF ../${PN}.jar avrora cck || die "failed to make a jar"
	cd ${S}

}

src_install() {
	use source && java-pkg_dosrc src
	use doc && java-pkg_dohtml -r doc

	java-pkg_dojar ${S}/${PN}.jar
	java-pkg_dolauncher
}
