# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 toolchain-funcs

MY_P=${PN}-${PV}

DESCRIPTION="The TinyOS tools"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://naurel.org/stuff/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="toscomm"
RDEPEND=">=dev-tinyos/nesc-1.2.7a
		 >=dev-java/ibm-jdk-bin-1.5"

S="${WORKDIR}/${MY_P}/tools"

src_unpack() {
	unpack ${A}
	cd "${S}"
	### needs some cleanup
	if use toscomm; then
		# not a good patch but bug evaporates when building with gcc 3.4.6
		ewarn "you are building tinyos-tools with toscomm use flag enabled, you then need to use tinyos-java-sdk merged with toscomm flag too "
		if [ `gcc-major-version` -ge 4 ] ; then
			einfo "  see http://sourceforge.net/tracker/index.php?func=detail&aid=1606811&group_id=28656&atid=393934"
			die "libtoscomm.so is buyggy when built against gcc-4"
		fi
	# bug in toscomm java vm plugin
	#epatch ${FILESDIR}/TOSComm_wrap.cxx.racecondition.patch
	else
		ewarn "you are building tinyos-tools with toscomm use flag Disabled, you then need to use a jdk with javacomm flag enabled"
		die "not yet functionnal .... patch under dev ..."
		#epatch ${FILESDIR}/somepatch.patch
	fi
	# tos-bsl needs to be actually "built" in order to adapt to the  correct libdir
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
	einfo "installing jni libs in  ${JNI}"
	into "${JNI}"
	dobin "${S}/tinyos/java/env/libgetenv.so"
	use javacomm && dobin "${S}/tinyos/java/serial/libtoscomm.so"
}
