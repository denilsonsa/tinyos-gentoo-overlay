# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

inherit eutils java-pkg-2

DESCRIPTION="The TinyOS tools to use deluge, progamation over the air for motes  "
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="source micaz mica2 telosb"
DEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	>=dev-tinyos/tos-getenv-1.1.15
	>=dev-tinyos/tos-util-1.1.15
	>=dev-tinyos/tos-message-1.1.15
	|| ( >=dev-tinyos/ncc-1.1.15
	     >=dev-tinyos/tinyos-tools-1.2.2 )
	source? ( app-arch/zip )
	mica2? ( cross-avr/gcc )
	micaz? ( cross-avr/gcc )
	telosb? ( cross-msp430/gcc ) "
RDEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	>=dev-tinyos/tos-getenv-1.1.15
	>=dev-tinyos/tos-util-1.1.15
	>=dev-tinyos/tos-message-1.1.15
	source? ( app-arch/zip ) "

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools/java

pkg_setup() {

	if ! built_with_use dev-java/ibm-jdk-bin javacomm ; then
		eerror "javacomm is required! Add javacomm to your use flag then re-emerge ibm-jdk-bin."
		eerror "Then re-emerge this package."
		die "setup failed due to missing prerequisite: javacomm"
	fi

	java-pkg-2_pkg_setup
	java-pkg_ensure-vm-version-ge 1 4 0
	local vendor=`java-utils_get-vm-vendor`
	einfo "${vendor} vm detected."
	if ! [[ ${vendor} = "ibm" ]]; then
		eerror "ibm-jdk-bin is required!"
		eerror "Please use java-config -S to set your system vm to a ibm-jdk."
		die "setup failed due to missing prerequisite: ibm-jdk-bin"
	fi
}

src_compile() {
	local cp="."
	cp=${cp}:$(java-pkg_getjars tos-util)
	cp=${cp}:$(java-pkg_getjars tos-message)
	cp=${cp}:${S}

	# build the stuff with mig
	sed -i 's@TOS = $(shell ncc -print-tosdir)@TOS=${S}/../../tos@g' net/tinyos/deluge/Makefile

	(use micaz && use mica2 || use micaz && use telosb || use telosb && use mica2 ) && die  "chose only one of mica2 micaz telosb "


	if  use micaz ; then
		 sed -i 's@DELUGE_PLATFORM=telosb@DELUGE_PLATFORM=micaz@g' net/tinyos/deluge/Makefile && einfo "building deluge for micaz" ||die
	elif use mica2 ; then
		sed -i 's@DELUGE_PLATFORM=telosb@DELUGE_PLATFORM=mica2@g' net/tinyos/deluge/Makefile && einfo "building deluge for mica2" || die
	elif  use telosb ;  then
		einfo "building deluge for telosb"
	else
		eerror "no platform chosen"
		die "chose one of mica2 micaz telosb"
	fi

	einfo "Creating java files with mig"
	make -C net/tinyos/deluge DelugeAdvMsg.java
	make -C net/tinyos/deluge DelugeReqMsg.java
	make -C net/tinyos/deluge DelugeDataMsg.java
	make -C net/tinyos/deluge NetProgMsg.java
	make -C net/tinyos/deluge DelugeConsts.java

	einfo "Compiling TinyOS Deluge"
	find net/tinyos/deluge -name "*.java" | xargs ejavac  -source 1.4 -classpath ${cp} -nowarn || die "Failed to compile"
	echo  "net/tinyos/tools/Deluge.java" | xargs ejavac -source 1.4 -classpath ${cp} -nowarn || die "Failed to compile"

	einfo "Packaging TinyOS Deluge"
	find net/tinyos/{deluge,tools}  -name "*.class" | xargs jar cf ${PN}.jar

}

src_install() {
	dobin ${FILESDIR}/deluge
	java-pkg_dojar ${PN}.jar
	use source && java-pkg_dosrc /net/tinyos/deluge
}
