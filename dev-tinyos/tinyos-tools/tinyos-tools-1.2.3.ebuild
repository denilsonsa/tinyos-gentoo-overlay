# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos-make/tos-make-1.1.15.ebuild,v 1.2 2006/08/09 19:51:22 sanchan Exp $

inherit eutils java-pkg-2 toolchain-funcs

MY_P=${PN}-${PV}

DESCRIPTION="The TinyOS tools"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://naurel.org/stuff/${MY_P}.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64" 
IUSE=""
#DEPEND=">=dev-tinyos/tos-2.0.0"

#        !dev-tinyos/listen
#        !dev-tinyos/tos-uisp
#        !dev-tinyos/channelgen"
#        !dev-tinyos/tos-getenv
#        !dev-tinyos/ncc"
RDEPEND=">=dev-tinyos/nesc-1.2.7a
         >=dev-java/ibm-jdk-bin-1.5"

# provides :

# >>> /usr/bin/mig
# >>> /usr/bin/ncc
# >>> /usr/bin/ncg
# deprecates dev-tinyos/ncc

# >>> /usr/bin/uisp
# deprecates  dev-tinyos/tos-uisp


# >>> /usr/bin/tos-write-image
# >>> /usr/bin/tos-serial-configure
# >>> /usr/bin/tos-locate-jre
# >>> /usr/bin/tos-storage-stm25p
# >>> /usr/bin/tos-serial-debug
# >>> /usr/bin/tos-check-env
# >>> /usr/bin/tos-set-symbols
# >>> /usr/bin/tos-bsl
# >>> /usr/bin/motelist


# >>> /usr/bin/tos-channelgen
# >>> /usr/bin/tos-ident-flags
# >>> /usr/bin/tos-mote-key
# >>> /usr/bin/tos-install-jni
# >>> /usr/bin/tos-storage-at45db
# >>> /usr/lib64/tinyos/elf.py
# --- /usr/lib64/tinyos/nesdoc/
# >>> /usr/lib64/tinyos/nesdoc/graph.py
# >>> /usr/lib64/tinyos/nesdoc/genhtml.py
# >>> /usr/lib64/tinyos/nesdoc/nesdoc.css
# >>> /usr/lib64/tinyos/nesdoc/interfaces.py
# >>> /usr/lib64/tinyos/nesdoc/archive.py
# >>> /usr/lib64/tinyos/nesdoc/components.py
# >>> /usr/lib64/tinyos/nesdoc/generators.py
# >>> /usr/lib64/tinyos/nesdoc/index.py
# >>> /usr/lib64/tinyos/nesdoc/html.py
# >>> /usr/lib64/tinyos/nesdoc/__init__.py
# >>> /usr/lib64/tinyos/nesdoc/utils.py
# --- /usr/lib64/tinyos/serial/
# >>> /usr/lib64/tinyos/serial/serialposix.py
# >>> /usr/lib64/tinyos/serial/serialwin32.py
# >>> /usr/lib64/tinyos/serial/serialutil.py
# >>> /usr/lib64/tinyos/serial/serialjava.py
# >>> /usr/lib64/tinyos/serial/__init__.py


#those two are move to the right directory 

# >>> /usr/lib64/tinyos/libtoscomm.so
# >>> /usr/lib64/tinyos/libgetenv.so

S=${WORKDIR}/${MY_P}/tools

src_unpack() {
	unpack ${A}
	cd ${S}

    ### needs some cleanup 
	# adapt to gentoo java handling 
	epatch ${FILESDIR}/tos-locate-jre_gentoo.patch
	epatch ${FILESDIR}/tos-java_make_fPIC.patch
	
	# not a good patch but bug evaporates when building with gcc 3.4.6
	
#	if [ `gcc-major-version` -ge 4 ] ; then 
#		einfo "  see http://sourceforge.net/tracker/index.php?func=detail&aid=1606811&group_id=28656&atid=393934" 
#		die "libtoscomm.so is buyggy when built against gcc-4"
#		
#	fi
	# bug in toscomm java vm plugin 
	#epatch ${FILESDIR}/TOSComm_wrap.cxx.racecondition.patch
	

	# tos-bsl needs to be actually "built" in order to adapt to tke libdir  
	rm ${S}/platforms/msp430/pybsl/tos-bsl


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
	into ${JNI}
 	dobin ${S}/tinyos/java/env/libgetenv.so 
	dobin ${S}/tinyos/java/serial/libtoscomm.so
}

