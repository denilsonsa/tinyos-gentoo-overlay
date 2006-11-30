# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos/tos-1.1.15-r1.ebuild,v 1.2 2006/08/09 19:42:12 sanchan Exp $
inherit eutils python


MY_PV=${PVR}
MY_P=tinyos-${MY_PV}
DOC_PV=${MY_PV}

DESCRIPTION="TinyOS: an open-source OS designed for wireless embedded sensor networks"
HOMEPAGE="http://www.tinyos.net/"
# tinyos.net does not provides tar.gz files anymore
#SRC_URI="http://www.tinyos.net/dist-2.0.0/tinyos/source/${MY_P}.tar.gz"
SRC_URI="http://www.naurel.org/stuff/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
DEPEND="doc? ( =tinyos-docs-${MY_PV} )"
RDEPEND=""

# Required to do anything useful. Could not be a RDEPEND since portage
# try to emerge nesc before tos.

PDEPEND="dev-tinyos/eselect-tinyos
         dev-tinyos/nesc
         !dev-tinyos/tos-make"

#those two are in the jar file 
PDEPEND="${PDEPEND} !dev-tinyos/tos-plot
	                 !dev-tinyos/serial-forwarder"


S=${WORKDIR}/${MY_P}
src_unpack() {
	unpack ${A}
	cd ${S}

	einfo "fixing sim.extra:"

	# 'fix' for gcc-4.1.1 see bug  #151832 an alternative is to use sys-devel/gcc => 4.1.2 or sys-devel/gcc <= 4.1
	# on amd64 only ? 
	einfo " -> gcc bug  "
	sed -i 's/OPTFLAGS = -g -O0/OPTFLAGS = -g -O2/g' support/make/sim.extra 

	# set the python version to use 
	python_version
	einfo " -> python version" ${PYVER}
	sed -i "s/PYTHON_VERSION=2.3/PYTHON_VERSION=${PYVER}/g" support/make/sim.extra 

}

src_compile() {
	einfo "FIXME, should compile the java stuff "
}

src_install() {
	TOSROOT=/usr/src/tinyos-2.x
	



	#dobin ${FILESDIR}/tos-bcastinject


	insinto ${TOSROOT}
	doins -r tos
	doins -r apps
	doins -r support
	chown -R root:0 "${D}"
	
	echo "VER=\"${PV}\"" > ${T}/${PV}
	echo "TOSROOT=\"${TOSROOT}\"" >>  ${T}/${PV}
	echo "TOSDIR=\"/usr/src/tinyos-2.x/tos\"">>  ${T}/${PV}
	echo "CLASSPATH=$CLASSPATH:$TOSROOT/support/sdk/java/tinyos.jar">>  ${T}/${PV}
	echo "MAKERULES=$TOSROOT/support/make/Makerules">>  ${T}/${PV}
	echo "PATH=/opt/msp430/bin:$PATH">>  ${T}/${PV}


 	local env_dir="/etc/env.d/tinyos/"
	dodir ${env_dir}
	insinto ${env_dir}
 	doins ${T}/${PV}

	# hack 
	ewarn "as a temporary measure and to prevent any modification to 1.x ebuild I will install eselect env file for 1.1.15 ebuild ..."
	doins ${FILESDIR}/1.1.15
	

}

pkg_postinst() {
	elog "If you want to use TinyOS on real hardware you need a cross compiler."
	elog "You should emerge sys-devel/crossdev and compile any toolchain you need"
	elog "Example: for Mica2 and Mica2 Dot: crossdev --target avr"
	ebeep 5
	epause 5
}

