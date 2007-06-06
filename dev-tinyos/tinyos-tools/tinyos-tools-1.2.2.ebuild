# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos-make/tos-make-1.1.15.ebuild,v 1.2 2006/08/09 19:51:22 sanchan Exp $

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


# >>> /usr/bin/mig
# >>> /usr/bin/ncc
# >>> /usr/bin/ncg
# >>> /usr/bin/uisp
# >>> /usr/bin/tos-write-image
# >>> /usr/bin/tos-serial-configure
# >>> /usr/bin/tos-locate-jre
# >>> /usr/bin/tos-storage-stm25p
# >>> /usr/bin/tos-serial-debug
# >>> /usr/bin/tos-check-env
# >>> /usr/bin/tos-set-symbols
# >>> /usr/bin/tos-bsl
# >>> /usr/bin/motelist
# >>> /usr/bin/nesdoc
# >>> /usr/bin/tos-channelgen
# >>> /usr/bin/tos-ident-flags
# >>> /usr/bin/tos-mote-key
# >>> /usr/bin/tos-install-jni
# >>> /usr/bin/tos-storage-at45db

S=${WORKDIR}/${MY_P}/tools

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/tos-locate-jre_gentoo.patch
	epatch ${FILESDIR}/tos-java_make_fPIC.patch
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
