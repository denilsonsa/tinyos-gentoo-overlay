# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils tinyos-java

DESCRIPTION="The plot utilities for TinyOS"
LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND=">=virtual/jdk-1.4
	>=dev-tinyos/tos-simdriver-1.1.15"
RDEPEND=">=virtual/jdk-1.4
	>=dev-tinyos/tos-simdriver-1.1.15"

TOS_PKG_JAVA_DIR="net/tinyos/plot"

src_compile() {
	java-pkg_addcp  $(java-pkg_getjars tos-simdriver)

	ewarn "FIXME" 
	# if this line is removed ejavac don't find anymore 
	# classes from jar files ? bug ?

	einfo "classpath = ${JAVA_PKG_CLASSPATH}"
	export CLASSPATH=${JAVA_PKG_CLASSPATH}

	tos_java_build_source
	tos_java_create_jar	
	# add extra to jar 
	find net/tinyos/plot -name "*.gif" | xargs jar uf ${PN}.jar
}
