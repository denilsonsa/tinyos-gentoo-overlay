# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 toolchain-funcs

MY_P=${PN}-${PV}

DESCRIPTION="The TinyOS tools"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://naurel.org/stuff/${P}.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND=">=dev-tinyos/nesc-1.2.7a
		 >=dev-java/ibm-jdk-bin-1.5"

S="${WORKDIR}/${MY_P}/tools"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# adapt to gentoo java handling
	epatch "${FILESDIR}/tos-locate-jre_gentoo.patch"
	epatch "${FILESDIR}/tos-java_make_fPIC.patch"

	# tos-bsl needs to be actually "built" in order to adapt to tke libdir
	rm "${S}/platforms/msp430/pybsl/tos-bsl"

	./Bootstrap || die "Failed to bootstrap"
}

src_compile(){
	econf || die "Failed to build "
	emake || die "Failed to build "
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	local JNI="$(java-config -O)/jre"
	einfo "installing libgetenv.so  and libtoscomm.so in  ${JNI}"
	into "${JNI}"
	dobin "${S}/tinyos/java/env/libgetenv.so"
	dobin "${S}/tinyos/java/serial/libtoscomm.so"
}

