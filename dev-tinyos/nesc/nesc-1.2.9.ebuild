# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/nesc/nesc-1.2.8a.ebuild,v 1.1 2006/12/26 12:01:32 sanchan Exp $

inherit eutils java-pkg-2 elisp-common

DESCRIPTION="An extension to gcc that knows how to compile nesC applications"
HOMEPAGE="http://nescc.sourceforge.net/"
SRC_URI="mirror://sourceforge/nescc/${P}.tar.gz"
LICENSE="GPL-2 Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc emacs"
JAVA_PKG_WANT_TARGET="1.4"
JAVA_PKG_WANT_SOURCE="1.4"
COMMON_DEP=">=dev-lang/perl-5.8.5-r2
	>=dev-tinyos/tos-1.1.0"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4.2"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4.2
	dev-perl/XML-Simple
	media-gfx/graphviz
	emacs? ( virtual/emacs )"

pkg_setup() {
	if [ -z "${TOSDIR}" ]
	then
		# best to make an assumption
		export TOSDIR=/usr/src/tinyos-1.x/tos
	fi

	if [ ! -d "${TOSDIR}" ]
	then
		eerror "In order to compile nesc you have to set the"
		eerror "\$TOSDIR environment properly."
		eerror ""
		eerror "You can achieve this by emerging >=dev-tinyos/tos-1.1.15"
		eerror "or by exporting TOSDIR=\"path to your tinyos dir\""
		die "Couldn't find a valid TinyOS home"
	else
		einfo "Building nesC for ${TOSDIR}"
	fi
	java-pkg-2_pkg_setup
}
src_unpack() {
	unpack ${A}
	# don't build java files from make
	sed -i -e 's/nodist_ncclib_DATA = nesc.jar/nodist_ncclib_DATA = /g' ${S}/tools/Makefile.in
	sed -i -e 's/SUBDIRS = java/SUBDIRS = /g' ${S}/tools/Makefile.in
	sed -i -e 's/NESC_JAR_DEPS = $(shell find java -name '*.java')//g' ${S}/tools/Makefile.in
	sed -i -e 's/nodist_ncclib_DATA = nesc.jar/nodist_ncclib_DATA = /g' ${S}/tools/Makefile.am
#	sed -i -e 's/^*java*$//g' ${S}/configure.in
}

src_compile() {

	econf --disable-dependency-tracking || die "econf failed"
	# language setting needed, otherwise gcc version
	# will sometimes not be detected right
	LANGUAGE=C emake || die "emake failed"

	einfo " cleanup the java mess"
	rm -f ${S}/tools/nesc.jar
	rm -f $(find ${S} -name "*.class" )

	# build java files with ejavac
	einfo "building java files with ejavac"
	ejavac $(find tools/java/ -name "*.java")
	cd tools/java ;
	jar cf ../${PN}.jar $(find . -name "*.class")
	cd ${S}
	if use emacs; then
		cd tools/editor-modes/emacs/
		elisp-comp *.el \
			|| die "failed to comple emacs mode files"
		cd ${S}
	fi

}

src_install() {
	LANGUAGE=C einstall || die "einstall failed"

	if use doc
	then
		dohtml -r -a html,jpg,pdf,txt doc/*
	fi
	# nesc relies on the fact that it will find nesc.jar into /usr/lib/ncc
	# it should be fixed to be gentoo compliant ...
	java-pkg_jarinto "${ROOT}"/usr/lib/ncc/
	java-pkg_dojar tools/nesc.jar

	if use emacs; then
		elisp-install ${PN} "${S}"/tools/editor-modes/emacs/*.el \
			"${S}"/tools/editor-modes/emacs/*.elc \
			|| die "elisp-site-file-install failed"
	fi


	newdoc README NEWS
	newdoc tools/java/net/tinyos/nesc/dump/README README.dump
	newdoc tools/java/net/tinyos/nesc/wiring/README README.wiring
}

pkg_postinst() {
	use emacs && elisp-site-regen
	elog "To install a nesC editor mode (currently, emacs, vim, kde):"
	elog "Read /usr/share/ncc/editor-modes/<your-editor-name>/readme.txt"
	elog ""
	elog "To use nesC with the Atmel AVR processors or the TI MSP processors you"
	elog "need the avr-gcc and msp430-gcc packages, and the corresponding GNU"
	elog "binutils (avr-binutils and msp430-binutils respectively)."
	elog "# emerge crossdev"
	elog "# crossdev -t avr"
	elog "# crossdev -t msp430"
	elog ""
	elog "You can use gcc <= 3.4.6 and binutils <= 2.16.1-r3 if you need $ in"
	elog "symbol names on avr or you can pass the -fnesc-separator=__ option to"
	elog "nescc (ncc if using TinyOS) to use __ rather than $ in generated code."
	elog "Example: PFLAGS=\"-fnesc-separator=__\" make mica2"
	elog "See the nescc man page for details."
	epause 5
}


pkg_postrm() {
		use emacs && elisp-site-regen
}

