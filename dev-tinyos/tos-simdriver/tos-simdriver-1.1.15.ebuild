# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils tinyos-java

DESCRIPTION="SimDriver is an extensible platform for interacting with TOSSIM/Nido, the TinyOS simulator."
LICENSE="Intel"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.4.0
	>=dev-java/oalnf-3.0
	>=dev-tinyos/tos-tython-1.1.15
	>=dev-tinyos/tos-sf-1.1.15
	|| ( >=dev-tinyos/ncc-1.1.15
         >=dev-tinyos/tinyos-tools-1.2.3)"
RDEPEND="${DEPEND}"

TOS_PKG_JAVA_DIR="net/tinyos/sim"
TOS_JAVA_LAUNCHER="tinyviz simdriver"

src_compile() {

	java-pkg_addcp $(java-pkg_getjars tos-tython)
	java-pkg_addcp $(java-pkg_getjars tos-sf)
	java-pkg_addcp $(java-pkg_getjars oalnf)

	ewarn "FIXME" 
	# if this line is removed ejavac don't find anymore 
	# classes from jar files ? bug ?

	einfo "classpath = ${JAVA_PKG_CLASSPATH}"
	export CLASSPATH=${JAVA_PKG_CLASSPATH}

	tos_java_build_source   
	make -C net/tinyos/sim  plugins/plugins.list
	einfo "Packaging TinyOS SimDriver"
	find net/tinyos/sim -name "*.class" | xargs $(java-config -j) cmf \
		net/tinyos/sim/simdriver.manifest \
		${PN}.jar \
		net/tinyos/sim/ui \
		net/tinyos/sim/plugins/plugins.list
 }

# src_install() {
# 	dodoc net/tinyos/sim/README net/tinyos/sim/TODO
# 	java-pkg_dojar ${PN}.jar
# 	use source && java-pkg_dosrc net/tinyos/sim
# 	dobin ${FILESDIR}/tinyviz
# 	dobin ${FILESDIR}/simdriver
# }
