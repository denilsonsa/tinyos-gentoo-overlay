# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos/tos-1.1.15-r1.ebuild,v 1.2 2006/08/09 19:42:12 sanchan Exp $
inherit eutils python

MY_PV=${PVR}
MY_P=tinyos-${MY_PV}
DOC_PV=${MY_PV}
DESCRIPTION="TinyOS java sdk"
HOMEPAGE="http://www.tinyos.net/"
# tinyos.net does not provides tar.gz files anymore
#SRC_URI="http://www.tinyos.net/dist-2.0.0/tinyos/source/${MY_P}.tar.gz"
SRC_URI="http://www.naurel.org/stuff/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="doc javacomm"
DEPEND=">=dev-tinyos/tinyos-tools-1.2.3
	>=dev-tinyos/tos-${PV}
	dev-tinyos/eselect-tinyos"
RDEPEND=">=dev-java/ibm-jdk-bin-1.5"
# Required to do anything useful. Could not be a RDEPEND since portage
# try to emerge nesc before tos.
PDEPEND="dev-tinyos/eselect-tinyos
	dev-tinyos/nesc"
#those two are in the jar file
PDEPEND="${PDEPEND}"
S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use javacomm  &&\
		! built_with_use dev-java/ibm-jdk-bin javacomm ; then
		eerror "javacomm support in ibm-jdk  is needed to build tos-sdk-c with javacomm support "
		eerror "either build tos-sdk-c without javacommm support (it will then use tinyos own java serial port driver) or"
		eerror "Add javacomm to your use flag then re-emerge ibm-jdk-bin and dev-tinyos/tinyos-tools."
		die "need javacomm support"
	fi
	if  use javacomm  &&\
		! built_with_use dev-tinyos/tinyos-tools javacomm; then
		eerror "javacomm support in tinyos-tools is needed to build tos-sdk-c with javacomm support "
		eerror "either build tos-sdk-c without javacommm support (it will then use tinyos own java serial port driver) or"
		eerror "Add javacomm to your use flag then re-emerge  dev-tinyos/tinyos-tools."
		die "need javacomm support"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	einfo "various fixes"
	export TOSROOT="${S}"
	export TOS="${S}"
	export TOSDIR="${TOS}/tos"
	# java build system minor patch
	einfo " java makefile clean target "
	epatch "${FILESDIR}/message_Makefile_clean-mig-target.patch"
	# replace the TOSComm Serial implementation with JavaComm-based code
	if use javacomm; then
		einfo "Using JavaComm-based serial communication instead of TOSComm."
		cp -f "${FILESDIR}/SerialByteSource-JavaComm.java" \
			"${S}/support/sdk/java/net/tinyos/packet/SerialByteSource.java"
	fi
}

src_compile() {
	einfo "compiling the java sdk"
	rm "${S}"/support/sdk/java/tinyos.jar
	CLASSPATH="${S}"/support/sdk/java/ make -C "${S}"/support/sdk/java/ tinyos.jar
	use doc && CLASSPATH="${S}"/support/sdk/java/ make -C "${S}"/support/sdk/java/ javadoc
}

src_install() {
	TOSROOT=/usr/src/tinyos-2.x
	insinto "${TOSROOT}/support/sdk/"
	doins -r support/sdk/java
	chown -R root:0 "${D}"
	if use doc; then
		insinto ${TOSROOT}/doc/html/
		doins -r "${S}"/doc/html/tos-javasdk-javadoc
	fi
}
