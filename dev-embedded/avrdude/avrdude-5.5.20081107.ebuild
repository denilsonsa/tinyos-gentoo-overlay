# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/avrdude/avrdude-5.5.ebuild,v 1.4 2008/07/30 07:00:31 solar Exp $

inherit cvs autotools

MY_DATE=${PV##*.}
MY_PV=${PV%.*}

ECVS_SERVER=cvs.savannah.nongnu.org:/sources/avrdude
ECVS_MODULE=avrdude
ECVS_CO_OPTS="-D ${MY_DATE}"
ECVS_UP_OPTS="$ECVS_CO_OPTS -dP"

S="$WORKDIR/$ECVS_MODULE"

WANT_AUTOMAKE=1.10
WANT_AUTOCONF=2.5

DESCRIPTION="AVR Downloader/UploaDEr"
HOMEPAGE="http://savannah.nongnu.org/projects/avrdude"
SRC_URI="!doc? ( http://savannah.nongnu.org/download/${PN}/${PN}-doc-${MY_PV}.tar.gz
		http://savannah.nongnu.org/download/${PN}/${PN}-doc-${MY_PV}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~ppc ~ppc64 ~x86"

IUSE="doc"
RDEPEND="dev-libs/libusb"
DEPEND="${RDEPEND}
	doc? ( app-text/texi2html
		virtual/latex-base
		sys-apps/texinfo )"

src_unpack() {
	cvs_src_unpack

	cd "${S}" || die
	eautoreconf
}

src_compile() {
	econf --disable-dependency-tracking --disable-doc || die "econf failed"

	# Re-adding -j1 here (see bug #202576) but that should be fixed someday
	emake -j1 || die "emake failed"

	# We build docs separately since the makefile doesn't do it in a really nice way
	if use doc ; then
		cd doc
		VARTEXFONTS="${T}/fonts" emake -j1 || die "emake doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS NEWS README ChangeLog*

	# We either install docs we just built or those pre-made by upstream
	insinto /usr/share/doc/${PF}
	if use doc ; then
		cd doc
		doins avrdude.{ps,pdf}
	else
		newins "${DISTDIR}/${PN}-doc-${MY_PV}.pdf" avrdude.pdf
		cd "${WORKDIR}"
	fi

	# where's html in cvs???
	#mv avrdude-html html
	#doins -r html
}
