# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils tinyos-java

DESCRIPTION="The TinyOS Simulator Message Library"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND=">=virtual/jdk-1.4
        >=dev-tinyos/tos-message-1.1.15
    ||( (>=dev-tinyos/ncc-1.1.15
         >=dev-tinyos/tos-getenv-1.1.15)
        >=dev-tinyos/tinyos-tools-1.2.3)
	=dev-tinyos/tos-1*"

RDEPEND=">=virtual/jre-1.4
         ||( >=dev-tinyos/tos-getenv-1.1.15
             >=dev-tinyos/tinyos-tools-1.2.3)
	     >=dev-tinyos/tos-message-1.1.15"

TOS_PKG_JAVA_DIR="net/tinyos/sim/msg"
src_compile() {
	local cp="."
	cp=${cp}:$(java-pkg_getjars tos-message)
	einfo "Compiling TinyOS Sim Message"

	if [[ ! -z  ${TOSDIR} ]]; then 
		sed -i "s@TOS = ../../../../../../tos@TOS = ${TOSDIR}@g" ${TOS_PKG_JAVA_DIR}/Makefile && einfo "Fixed TOS dir" 
	fi 
	CLASSPATH=${cp} make -C ${TOS_PKG_JAVA_DIR} 
	einfo "Packaging TinyOS Sim Message"
	tos_java_create_jar
}
