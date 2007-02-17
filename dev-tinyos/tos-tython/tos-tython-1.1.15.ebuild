# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

inherit java-pkg

DESCRIPTION="TinyOS Jython patched version"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel JPython Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="jikes source doc readline"
RDEPEND=">=virtual/jre-1.2
	readline? ( >=dev-java/libreadline-java-0.8.0 )
	jikes? ( >=dev-java/jikes-1.18 )"

DEPEND=">=virtual/jdk-1.2
	source? ( app-arch/zip )
	${RDEPEND}"


S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools/java

src_compile() {
	javac=$(java-config -c)
	if use jikes ; then
		java=$(which jikes)
	fi

	local cp="."
	local exclude=""

	einfo "Compiling patched version of Jython 2.2a0"
	if use readline ; then
		cp=${cp}:$(java-pkg_getjars libreadline-java)
	else
		exclude="${exclude} ! -name ReadlineConsole.java"
	fi
	find org -name "*.java" ${exclude} | xargs ${javac} -source 1.3 -classpath ${cp} -nowarn || die "Failed to compile"

	einfo "Packaging patched version of Jython 2.2a0"
	find org -name "*.class" | xargs jar cf ${PN}.jar
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dodoc org/README
	docinto python
	dodoc org/python/ACKNOWLEDGMENTS org/python/README.TXT
	use source && java-pkg_dosrc org
}

pkg_postinst() {
	if use readline; then
		einfo "To use readline you need to add the following to your registry"
		einfo
		einfo "python.console=org.python.util.ReadlineConsole"
		einfo "python.console.readlinelib=GnuReadline"
	fi
}
