# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos/tos-1.1.15-r1.ebuild,v 1.2 2006/08/09 19:42:12 sanchan Exp $
inherit eutils python java


MY_PV=${PV}
MY_P=tinyos-${MY_PV}
DOC_PV=${MY_PV}

DESCRIPTION="TinyOS: an open-source OS designed for wireless embedded sensor networks"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-2.1.0/tinyos/source/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="doc source"
DEPEND=" dev-tinyos/nesc"
#	 doc? ( =dev-tinyos/tinyos-docs-${MY_PV} )"


S=${WORKDIR}/${MY_P}/support/sdk/c
src_unpack() {
	unpack ${A}
	cd "${S}"

	export TOSROOT="/usr/src/tinyos-2.x"
	export TOS="${TOSROOT}"
	export TOSDIR="${TOS}/tos"
}

src_compile() {
	einfo "building serial forwarder tools"
	cd "${S}/sf"
	./bootstrap
	econf || die "econf failed"
	emake || die "emake failed"

	einfo "building 6lowpan tools"
	cd "${S}/6lowpan/serial_tun"
	TOSROOT="${WORKDIR}/${MY_P}" make ||die
}

src_install() {
	TOSROOT=/usr/src/tinyos-2.x

	# installing binaries
	for i in sf/seriallisten sf/sflisten sf/sfsend sf/prettylisten sf/sf 6lowpan/serial_tun/serial_tun ; do
		dobin "${S}"/${i}
	done

	# installing libmote.a this library provides low level serial packets access to motes
	dolib.a "${S}"/sf/libmote.a

	# linking libmote into /usr/src/tinyos-2.x/ some makefiles looks for ot here
	# TODO find a better way to find target of link
	dodir ${TOSROOT}/support/sdk/c/sf
	dosym /usr/lib/libmote.a ${TOSROOT}/support/sdk/c/sf/libmote.a

	# installs include files for libmote.a
	insinto /usr/include
	doins sf/message.h
	doins sf/sfsource.h
	doins sf/serialsource.h
	doins sf/serialprotocol.h
	doins sf/serialpacket.h

	if use source ; then
		# installing sdk source code
		# cleaning up
		make distclean
		rm -rf autom4te.cache .deps config-aux aclocal.m4
		insinto ${TOSROOT}
		dodir ${TOSROOT}/support/sdk/
		insinto ${TOSROOT}/support/sdk/
		doins -r "${S}"
		chown -R root:root "${D}"
	fi
}

pkg_postinst(){
	use source && einfo "TinyOS C SDK source is installed in  ${TOSROOT}/support/sdk/c"
}
