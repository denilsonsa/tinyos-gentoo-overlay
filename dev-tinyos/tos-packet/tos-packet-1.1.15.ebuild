# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils tinyos-java

DESCRIPTION="The basic underlying abstraction for TinyOS packet-format layer"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.4
	|| ( >=dev-tinyos/tos-getenv-1.1.15
		>=dev-tinyos/tinyos-tools-1.2.3 )
	>=dev-tinyos/tos-util-1.1.15
	>=dev-tinyos/tos-message-1.1.15"
RDEPEND="${DEPEND}"

TOS_PKG_JAVA_DIR="net/tinyos/packet"

src_compile() {
	java-pkg_addcp $(java-pkg_getjars tos-util)
	java-pkg_addcp $(java-pkg_getjars tos-message)
   
	tos_java_build_source
	tos_java_create_jar
}
