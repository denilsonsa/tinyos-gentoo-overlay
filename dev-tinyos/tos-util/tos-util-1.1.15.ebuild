# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

inherit eutils java-pkg-2 

DESCRIPTION="Utility classes for TinyOS java applictions"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="source"
DEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	>=dev-java/java-config-2
	source? ( app-arch/zip )"
RDEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	|| ( >=dev-tinyos/tos-getenv-1.1.15
         >=dev-tinyos/tinyos-tools-1.2.3)
	source? ( app-arch/zip )"

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools/java

pkg_setup() {
	if ! built_with_use dev-java/ibm-jdk-bin javacomm ; then
		eerror "javacomm is required! Add javacomm to your use flag then re-emerge ibm-jdk-bin."
		eerror "Then re-emerge this package."
		die "setup failed due to missing prerequisite: javacomm"
	fi

	java-pkg-2_pkg_setup
	java-pkg_ensure-vm-version-ge 1 4 0
	local vendor=`java-pkg_get-vm-vendor`
	einfo "${vendor} vm detected."
	if ! [[ ${vendor} = "ibm" ]]; then
		eerror "ibm is required!"
		eerror "Please use java-config -S to set your system vm to a ibm-jdk."
		die "setup failed due to missing prerequisite: ibm-jdk-bin"
	fi
}


src_compile() {
	local cp="."
	einfo "Compiling TinyOS java utils"
	find net/tinyos/util -name "*.java" | xargs $(java-config-2 -c) -source 1.4 -classpath ${cp} -nowarn || die "Failed to compile"
	einfo "Packaging TinyOS java utils"
	find net/tinyos/util -name "*.class" | xargs $(java-config-2 -j) cf ${PN}.jar
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dodoc net/tinyos/util/README
	use source && java-pkg_dosrc net/tinyos/util
}

