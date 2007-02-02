# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

inherit eutils java-pkg java-utils

DESCRIPTION="SimDriver is an extensible platform for interacting with TOSSIM/Nido, the TinyOS simulator."
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="source"
DEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	dev-java/java-config
	>=dev-java/oalnf-3.0
	>=dev-tinyos/tos-util-1.1.15
	>=dev-tinyos/tos-message-1.1.15
	>=dev-tinyos/tos-tython-1.1.15
	>=dev-tinyos/tos-sf-1.1.15
	>=dev-tinyos/tos-packet-1.1.15
	>=dev-tinyos/ncc-1.1.15
	source? ( app-arch/zip )"
RDEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	>=dev-java/oalnf-3.0
	>=dev-tinyos/tos-getenv-1.1.15
	>=dev-tinyos/tos-util-1.1.15
	>=dev-tinyos/tos-message-1.1.15
	>=dev-tinyos/tos-tython-1.1.15
	>=dev-tinyos/tos-sf-1.1.15
	>=dev-tinyos/tos-packet-1.1.15
	source? ( app-arch/zip )"

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools/java

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


src_compile() {
	local cp="."
	cp=${cp}:$(java-pkg_getjars tos-util)
	cp=${cp}:$(java-pkg_getjars tos-message)
	cp=${cp}:$(java-pkg_getjars tos-tython)
	cp=${cp}:$(java-pkg_getjars tos-sim-msg)
	cp=${cp}:$(java-pkg_getjars tos-sf)
	cp=${cp}:$(java-pkg_getjars tos-packet)
	cp=${cp}:$(java-pkg_getjars oalnf)

	#Makefile broken, compiling by hand
	einfo "Compiling TinyOS SimDriver"
	find net/tinyos/sim -name "*.java" | xargs $(java-config -c) -source 1.4 -classpath ${cp} || die "Failed to compile"
	make -C net/tinyos/sim  plugins/plugins.list
	einfo "Packaging TinyOS SimDriver"
	find net/tinyos/sim -name "*.class" | xargs $(java-config -j) cmf \
		net/tinyos/sim/simdriver.manifest \
		${PN}.jar \
		net/tinyos/sim/ui \
		net/tinyos/sim/plugins/plugins.list
}

src_install() {
	dodoc net/tinyos/sim/README net/tinyos/sim/TODO
	java-pkg_dojar ${PN}.jar
	use source && java-pkg_dosrc net/tinyos/sim
	dobin ${FILESDIR}/tinyviz
	dobin ${FILESDIR}/simdriver
}
