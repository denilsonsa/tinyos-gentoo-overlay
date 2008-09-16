# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${PN}-${PV}

DESCRIPTION="The TinyOS tools"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-2.0.0/tinyos/source/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=">=dev-tinyos/tos-2.0.0_beta2
		!dev-tinyos/listen
		!dev-tinyos/tos-uisp
		!dev-tinyos/tos-getenv
		!dev-tinyos/channelgen
		!dev-tinyos/ncc"
RDEPEND=">=dev-tinyos/nesc-1.2.7a
		>=dev-java/ibm-jdk-bin-1.5"

S="${WORKDIR}/${MY_P}/tools"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/tos-locate-jre_gentoo.patch"
	epatch "${FILESDIR}/tos-java_make_fPIC.patch"
	./Bootstrap || die "Failed to bootstrap"
}

src_compile(){
	econf || die "Failed to build "
	emake || die "Failed to build "
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	elog "In order to use this, just add in your Makefile something like:"
	elog "TOSMAKE_PATH += \${YOUR_ADDITIONAL_RULES_DIRECTORY}"
	elog "MAKERULES = \${TOSROOT}/tools/make/Makerules\n"

	elog "If you want to use TinyOS on real hardware you need a cross compiler."
	elog "You should emerge sys-devel/crossdev and compile any toolchain you need"
	elog "Example: for Mica2 and Mica2 Dot: crossdev --target avr"
	elog "You also need >=dev-tinyos/tos-uisp-1.1.14 in order to flash your mote."
	elog "You also need >=dev-java/ibm-sdk-bin-1.4.0 if you plan to use deluge."

	ebeep 5
	epause 5
}
