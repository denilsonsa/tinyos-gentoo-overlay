# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos/tos-1.1.15-r1.ebuild,v 1.2 2006/08/09 19:42:12 sanchan Exp $
inherit eutils


MY_PV=${PV/_beta/beta}
MY_P=tinyos-${MY_PV}
DOC_PV=${MY_PV/_beta/beta}

DESCRIPTION="TinyOS: an open-source OS designed for wireless embedded sensor networks"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-2.0.0/tinyos/source/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
#DEPEND="doc? ( =dev-tinyos/tinyos-doc-${MY_PV} )"
DEPEND=""
RDEPEND=""

#Required to do anything useful. Could not be a RDEPEND since portage try to emerge nesc before tos.
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
}

src_compile() {
	einfo "FIXME, should compile the java stuff "
}

src_install() {
	insinto /usr/src/tinyos-2.x
	doins -r tos
	doins -r apps
	doins -r support
	chown -R root:0 "${D}"

	echo "VER=\"${PV}\"" > ${T}/${PV}
	echo "TOSROOT=\"/usr/src/tinyos-2.x\"" >>  ${T}/${PV}
	echo "TOSDIR=\"/usr/src/tinyos-2.x/tos\"">>  ${T}/${PV}
	echo "CLASSPATH=$CLASSPATH:$TOSROOT/support/sdk/java/tinyos.jar">>  ${T}/${PV}
	echo "MAKERULES=$TOSROOT/support/make/Makerules">>  ${T}/${PV}
	echo "PATH=/opt/msp430/bin:$PATH">>  ${T}/${PV}

 	env_dir="/etc/env.d/tinyos/"
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

