# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

inherit java-pkg java-utils

DESCRIPTION="The basic underlying abstraction for TinyOS packet-format layer"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="1"
KEYWORDS="~x86"
IUSE="source"
DEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	dev-java/java-config
	source? ( app-arch/zip )"
RDEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	source? ( app-arch/zip )"

S="${WORKDIR}/tinyos-1.x/tools/java"

pkg_setup() {
	java-utils_setup-vm
	java-utils_ensure-vm-version-ge 1 4 0

	local vendor=`java-utils_get-vm-vendor`
	einfo "${vendor} vm detected."
	if ! [[ ${vendor} = "ibm-jdk-bin" ]]; then
		eerror "ibm-jdk-bin is required!"
		eerror "Please use java-config -S to set your system vm to a ibm-jdk."
		die "setup failed due to missing prerequisite: ibm-jdk-bin"
	fi
}


src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	mv ${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs tinyos-1.x
}

src_compile() {
	local cp="."

    #Makefile broken, compiling by hand
	einfo "Compiling TinyOS Listen"
	cd ${S}
    $(java-config -c) -source 1.4 -classpath ${cp} -nowarn net/tinyos/tools/Listen.java  || die "Failed to compile"
	einfo "Packaging TinyOS Listen"
	jar cf ${PN}.jar net/tinyos/tools/Listen.class
}

src_install() {
	cd ${S}
	java-pkg_dojar ${PN}.jar
	use source && java-pkg_dosrc /net/tinyos/tools/Listen.java
	dobin ${FILESDIR}/tos-Listen
}
