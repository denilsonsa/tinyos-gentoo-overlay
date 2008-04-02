# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils tinyos-java

DESCRIPTION="TinyOS serial forwarder multiplexer: provides serial port multiplexing"
LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 ~x86"
DEPEND=">=virtual/jdk-1.4
	|| ( >=dev-tinyos/tos-getenv-1.1.15
		>=dev-tinyos/tinyos-tools-1.2.3 )
	>=dev-tinyos/tos-packet-1.1.15
	>=dev-tinyos/tos-sim-msg-1.1.15"

RDEPEND=">=virtual/jdk-1.4
		|| ( >=dev-tinyos/tos-getenv-1.1.15
		>=dev-tinyos/tinyos-tools-1.2.3 )
		>=dev-tinyos/tos-packet-1.1.15
		>=dev-tinyos/tos-sim-msg-1.1.15"

TOS_PKG_JAVA_DIR="net/tinyos/sf"
TOS_JAVA_LAUNCHER=tos-sf
TOS_JAVA_LAUNCHER_MAIN=net.tinyos.sf.SerialForwarder
TOS_JAVA_SOURCESFILES="net/tinyos/sf/SerialForwarder.java
	net/tinyos/sf/SFConsoleRenderer.java
	net/tinyos/sf/SFRenderer.java
	net/tinyos/sf/SFClient.java
	net/tinyos/sf/SFListen.java
	net/tinyos/sf/SFWindow.java"

src_compile() {
	java-pkg_addcp $(java-pkg_getjars tos-util)
	java-pkg_addcp $(java-pkg_getjars tos-message)
	java-pkg_addcp $(java-pkg_getjars tos-packet)
	java-pkg_addcp $(java-pkg_getjars tos-sim-msg)

	tos_java_build_source
	tos_java_create_jar
}
