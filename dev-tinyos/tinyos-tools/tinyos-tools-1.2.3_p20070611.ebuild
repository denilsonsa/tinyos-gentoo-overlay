# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos-make/tos-make-1.1.15.ebuild,v 1.2 2006/08/09 19:51:22 sanchan Exp $

inherit eutils java-pkg-2 toolchain-funcs

MY_P=${PN}-${PV}

DESCRIPTION="The TinyOS tools"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://naurel.org/stuff/${PF}.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="javacomm"

RDEPEND=">=dev-tinyos/nesc-1.2.7a
		 >=dev-java/ibm-jdk-bin-1.5"


S=${WORKDIR}/${MY_P}/tools

src_unpack() {
	unpack ${A}
	cd ${S}

	### needs some cleanup

	# not a good patch but bug evaporates when building with gcc 3.4.6

	if  ! use javacomm && [ `gcc-major-version` -ge 4 ] ; then
		einfo "  see http://sourceforge.net/tracker/index.php?func=detail&aid=1606811&group_id=28656&atid=393934"
		eerror "libtoscomm.so is buyggy when built against gcc-4,  will downgrade CFLAGS... should work"
	fi

	# remove -m32 flag, breaks on amd64 hosts 
	einfo "remove -m32 flag, breaks on amd64 hosts "
	sed -i 's/-m32//' ${S}/tinyos/java/env/Makefile.am || die "failed to fix tinyos/java/env/Makefile.am"
	sed -i 's/-O2/-O1/' ${S}/tinyos/java/env/Makefile.am || die "failed to fix tinyos/java/env/Makefile.am"
	sed -i 's/-m32//' ${S}/tinyos/java/serial/Makefile.am|| die "failed to fix tinyos/java/serial/Makefile.am"
	sed -i 's/-O2/-O1/' ${S}/tinyos/java/serial/Makefile.am|| die "failed to fix tinyos/java/serial/Makefile.am"

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
	dobin ${S}/tinyos/java/env/libgetenv.so

	if ! use javacomm; then
		einfo "installing  libtoscomm.so in  ${JNI}"
		dobin ${S}/tinyos/java/serial/libtoscomm.so
	fi

	# useless there, we install them in the proper jdk directory...
	rm ${D}/usr/lib64/tinyos/libtoscomm.so
	rm ${D}/usr/lib64/tinyos/libgetenv.so
}
