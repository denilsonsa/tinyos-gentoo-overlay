# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"
inherit tinyos-java

DESCRIPTION="The basic underlying abstraction for TinyOS packet-format layer"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE="source"
COMMON_DEP="source? ( app-arch/zip )
>=dev-java/ibm-jdk-bin-1.4.0"
DEPEND=">=virtual/jdk-1.4
	dev-java/java-config
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
S="${WORKDIR}/tinyos-1.x/tools/java"

pkg_setup() {
	tinyos_check_vm
}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	mv "${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs" tinyos-1.x
}

src_compile() {
	local cp="."
	#Makefile broken, compiling by hand
	einfo "Compiling TinyOS Listen"
	$(java-config -c) -source 1.4 -classpath "${cp}" -nowarn net/tinyos/tools/Listen.java  || die "Failed to compile"
	einfo "Packaging TinyOS Listen"
	jar cf "${PN}.jar" net/tinyos/tools/Listen.class
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use source && java-pkg_dosrc /net/tinyos/tools/Listen.java
	dobin "${FILESDIR}/tos-Listen"
}
