# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg java-utils

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

DESCRIPTION="The plot utilities for TinyOS"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="source"
DEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	dev-java/java-config
	>=dev-tinyos/tos-simdriver-1.1.15
	source? ( app-arch/zip )"
RDEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	>=dev-tinyos/tos-simdriver-1.1.15
	source? ( app-arch/zip )"

S="${WORKDIR}/tinyos-1.x/tools/java"

pkg_setup() {
	if ! built_with_use dev-java/ibm-jdk-bin javacomm ; then
		eerror "javacomm is required! Add javacomm to your use flag then re-emerge ibm-jdk-bin."
		eerror "Then re-emerge this package."
		die "setup failed due to missing prerequisite: javacomm"
	fi

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
	cp=${cp}:$(java-pkg_getjars tos-simdriver)

	#Makefile broken, compiling by hand
	einfo "Compiling TinyOS plot"
	cd ${S}
	find net/tinyos/plot -name "*.java" | xargs $(java-config -c) -source 1.4 -classpath ${cp} -nowarn || die "Failed to compile"
	einfo "Packaging TinyOS plot"
	find net/tinyos/plot -name "*.class" | xargs jar cf ${PN}.jar
	find net/tinyos/plot -name "*.gif" | xargs jar uf ${PN}.jar
}

src_install() {
	cd ${S}
	java-pkg_dojar ${PN}.jar
	use source && java-pkg_dosrc /net/tinyos/message
}
