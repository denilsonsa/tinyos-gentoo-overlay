# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils python

MY_PV=${PV}
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
IUSE="doc source"
DEPEND=" dev-tinyos/nesc
	 doc? ( =dev-tinyos/tinyos-docs-${MY_PV} )"

S=${WORKDIR}/${MY_P}/support/sdk/c
src_unpack() {
	unpack ${A}
	cd "${S}"
	export TOSROOT="/usr/src/tinyos-2.x"
	export TOS="${TOSROOT}"
	export TOSDIR="${TOS}/tos"
}

src_compile() {
	./bootstrap
	econf || die "econf failed"
	einfo "compiling the c sdk"
	emake || die "emake failed"
}

src_install() {
	TOSROOT=/usr/src/tinyos-2.x

	# installing binaries
	for i in seriallisten sflisten sfsend prettylisten sf ; do
		dobin "${S}/${i}"
	done
	# installing libmote.a this library provides low level serial packets access to motes
	dolib.a "${S}/libmote.a"

	# installs include files for libmote.a
	insinto /usr/include
	doins message.h
	doins sfsource.h
	doins serialsource.h
	doins serialprotocol.h
	doins serialpacket.h

	if use source ; then
		# installing sdk source code
		#cleaning up
		make distclean
		rm -rf autom4te.cache .deps config-aux  aclocal.m4
		insinto ${TOSROOT}
		dodir ${TOSROOT}/support/sdk/
		insinto ${TOSROOT}/support/sdk/
		doins -r "${S}"
		chown -R root:root "${D}"
	fi
}

pkg_postinst(){
	use source && einfo "TinyOS C SDK source is installed in  ${TOSROOT}/support/sdk/c "
}

