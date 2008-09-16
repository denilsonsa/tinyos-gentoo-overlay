# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 toolchain-funcs

DESCRIPTION="The TinyOS tools"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://naurel.org/stuff/${PF}.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="javacomm"

RDEPEND=">=dev-tinyos/nesc-1.2.7a
		 !javacomm? ( >=virtual/jdk-1.5 )
		 javacomm? ( >=dev-java/ibm-jdk-bin-1.5 )"


S=${WORKDIR}/${P}/tools

src_unpack() {
	unpack ${A}
	cd "${S}"
	### needs some cleanup
	# not a good patch but bug evaporates when building with gcc 3.4.6

	if  ! use javacomm && [ `gcc-fullversion` -ge 4.1.1  ] ; then
		einfo "  see http://sourceforge.net/tracker/index.php?func=detail&aid=1606811&group_id=28656&atid=393934"
		eerror "libtoscomm.so is buyggy when built against gcc-4.1.1,  will downgrade CFLAGS... should work"
	fi

	if use javacomm ; then
		ewarn "to my experience javacomm works only if youare actually using ibm-sdk and it does not "
		ewarn "really know how to handle linux devices keep on looking for COM0 ports and the like ..."
		ewarn "if you run into such trouble you can try to buid this ebuild AND tos-sdk-java with "
		ewarn "javacomm desactivated "
	fi

	# remove -m32 flag, breaks on amd64 hosts
	einfo "remove -m32 flag, breaks on amd64 hosts "
	sed -i 's/-m32//' "${S}"/tinyos/java/env/Makefile.am || die "failed to fix tinyos/java/env/Makefile.am"
	sed -i 's/-O2/-O1/' "${S}"/tinyos/java/env/Makefile.am || die "failed to fix tinyos/java/env/Makefile.am"
	sed -i 's/-m32//' "${S}"/tinyos/java/serial/Makefile.am|| die "failed to fix tinyos/java/serial/Makefile.am"
	sed -i 's/-O2/-O1/' "${S}"/tinyos/java/serial/Makefile.am|| die "failed to fix tinyos/java/serial/Makefile.am"

	epatch "${FILESDIR}/${P}-include-missing.patch"
	#TODO: move /usr/lib64/tinyos/nesdoc/*.py in /usr/lib64/python...
	./Bootstrap || die "Failed to bootstrap"
}

src_compile(){
	econf || die "Failed to build "
	emake || die "Failed to build "
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	local JNI="$(java-config -O)/jre"
	einfo "installing libgetenv.so in  ${JNI}"
	into ${JNI}
	local ARCH=32
	[[ $(tc-arch) == "amd64"  ]] && ARCH=64
	dobin "${S}"/tinyos/java/env/libgetenv-${ARCH}.so
	if ! use javacomm; then
		einfo "installing  libtoscomm-${ARCH}.so in  ${JNI}"
		dobin "${S}"/tinyos/java/serial/libtoscomm-${ARCH}.so
	fi
}
