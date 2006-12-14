# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTE: The comments in this file are for instruction and documentation.
# They're not meant to appear with your final, production ebuild.  Please
# remember to remove them before submitting or committing your ebuild.  That
# doesn't mean you can't add your own comments though.

# The 'Header' on the third line should just be left alone.  When your ebuild
# will be committed to cvs, the details on that line will be automatically
# generated to contain the correct data.

# inherit lists eclasses to inherit functions from. Almost all ebuilds should
# inherit eutils, as a large amount of important functionality has been
# moved there. For example, the $(get_libdir) mentioned below wont work
# without the following line:
inherit eutils cvs java-pkg-2

ECVS_SERVER="samoa.cs.ucla.edu:/project/cvs/pub"

ECVS_MODULE="avrora"
ECVS_AUTH="pserver"
ECVS_USER="anonymous"

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="AVR simulation and analysis framework"
HOMEPAGE="http://compilers.cs.ucla.edu/avrora/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"



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
