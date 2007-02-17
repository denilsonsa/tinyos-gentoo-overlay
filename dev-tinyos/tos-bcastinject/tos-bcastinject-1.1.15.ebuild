# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

inherit eutils java-pkg java-utils

DESCRIPTION="The TinyOS tools to use deluge, progamation over the air for motes  "
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="source micaz mica2 telosb"
DEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	dev-java/java-config
	>=dev-tinyos/tos-getenv-1.1.15
	>=dev-tinyos/tos-util-1.1.15
	>=dev-tinyos/tos-message-1.1.15
	>=dev-tinyos/ncc-1.1.15
	source? ( app-arch/zip )
    mica? (cross-avr/gcc)
    micz? (cross-avr/gcc)
    telosb? (cross-msp430/gcc)"
RDEPEND=">=dev-java/ibm-jdk-bin-1.4.0
	>=dev-tinyos/tos-getenv-1.1.15
	>=dev-tinyos/tos-util-1.1.15
	>=dev-tinyos/tos-message-1.1.15
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
	cp=${cp}:${S}

	
	sed -i 's|SIMPLECMD_LIB=$(TOS)/../apps/SimpleCmd|SIMPLECMD_LIB?=$(TOS)/../apps/SimpleCmd|g' net/tinyos/tools/Makefile
	
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
	make -C net/tinyos/tools  SimpleCmdMsg.java
	make -C net/tinyos/tools  LogMsg.java

#	einfo "Compiling TinyOS Deluge"
#	find net/tinyos/deluge -name "*.java" | xargs $(java-config-2 -c) -source 1.4 -classpath ${cp} -nowarn || die "Failed to compile"
	
	J_FILES="net/tinyos/tools/SimpleCmdMsg.java\
 net/tinyos/tools/LogMsg.java\
 net/tinyos/tools/BcastInject.java "
	echo ${J_FILES}
	echo ${J_FILES} | xargs $(java-config-2 -c) -source 1.4 -classpath ${cp} -nowarn || die "Failed to compile"


	einfo "Packaging TinyOS Bcast Inject"
	find net/tinyos/tools  -name "*.class" | xargs jar cf ${PN}.jar 
}

src_install() {
	dobin ${FILESDIR}/tos-bcastinject
	java-pkg_dojar ${PN}.jar
	use source && java-pkg_dosrc /net/tinyos/tools/BcastInject.java	e
	einfo "if you want to build the tool against your own application run :"
	einfo "SIMPLECMD_LIB='path to your dir containing SimpleCmdMsg.h'  emerge tos-bcastinject "
	einfo "otherwise the tool will be built against default app \$\(TOSDIR\)/apps/SimpleCmd"
}
