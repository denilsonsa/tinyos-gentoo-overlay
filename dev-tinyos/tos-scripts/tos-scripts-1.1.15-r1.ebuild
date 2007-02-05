# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/tos-scripts/tos-scripts-1.1.15-r1.ebuild,v 1.2 2006/11/14 21:50:28 sanchan Exp $

inherit eutils java-pkg-2

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

DESCRIPTION="The TinyOS Make System"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=">=dev-tinyos/tos-1.1.15"
RDEPEND="|| (>=dev-tinyos/ncc-1.1.15
             >=dev-tinyos/tinyos-tools-1.2.3)
	>=dev-java/ibm-jdk-bin-1.4.0"

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools

pkg_setup() {
	if [ -z "${TOSROOT}" ]
	then
		# best to make an assumption
		export TOSDIR=/usr/src/tinyos-1.x/tos
	fi

	if [ ! -d "${TOSROOT}" ]
	then
		eerror "In order to compile nesc you have to set the"
		eerror "\$TOSROOT environment properly."
		eerror ""
		eerror "You can achieve this by emerging >=dev-tinyos/tos-1.1.15"
		eerror "or by exporting TOSDIR=\"path to your tinyos dir\""
		die "Couldn't find a valid TinyOS home"
	else
		einfo "Building tos-scripts for ${TOSROOT}"
	fi

	if ! built_with_use dev-java/ibm-jdk-bin javacomm ; then
		eerror "javacomm is required! Add javacomm to your use flag then re-emerge ibm-jdk-bin."
		eerror "Then re-emerge this package."
		die "setup failed due to missing prerequisite: javacomm"
	fi
	java-pkg-2_pkg_setup
	java-pkg_ensure-vm-version-ge 1 4 0
	local vendor=`java-pkg_get-vm-vendor`
	einfo "${vendor} vm detected."
	if ! [[ ${vendor} = "ibm" ]]; then
		eerror "ibm-jdk-bin is required!"
		eerror "Please use java-config -S to set your system vm to a ibm-jdk."
		die "setup failed due to missing prerequisite: ibm-jdk-bin"
	fi
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	local EXES="mote-key toscheck tinyos-serial-configure set-mote-id locate-jre"
	local TSCRIPT=${TOSROOT}/tools/scripts
	local PTOSSIM=${TSCRIPT}/PowerTOSSIM
	local CODEGEN=${TSCRIPT}/codeGeneration
	insinto ${TOSROOT}/tools
	doins -r scripts
	for i in bb2asm.pl bb2cycle.pl cilly.asm.exe compile.pl counter.ml cpuprof.py fixnames.pl mypp.pl postprocess.py
	do
		fperms 755 ${PTOSSIM}/${i}
	done
	for i in generateHood.pl generateNescDecls.pl generateRegistry.pl generateRpc.pl
	do
		fperms 755 ${CODEGEN}/${i}
	done
	for i in ${EXES} write_tos_image taskCount.pl prepare-ChangeLog.pl ident_flags
	do
		fperms 755 ${TSCRIPT}/${i}
	done
	cd scripts
	into /usr
	dobin ${EXES}
	newdoc PowerTOSSIM/README README.PowerTOSSIM
	newdoc codeGeneration/README README.codeGeneration
}

pkg_postinst() {
	elog "In order to automatically use codeGeneration emerge tos-make,"
	elog "add in your Makefile something like:"
	elog "TOSMAKE_PATH += \${TOSROOT}/tools/scripts/codeGeneration"
	elog "and add registy, hood or rpc to your make target eg.: make pc hood"

	elog "If you want to use TinyOS on real hardware you need a cross compiler."
	elog "You should emerge sys-devel/crossdev and compile any toolchain you need"
	elog "Example: for Mica2 and Mica2 Dot: crossdev --target avr"
	elog "You also need >=dev-tinyos/tos-uisp-1.1.14 in order to flash your mote."

	ebeep 5
	epause 5
}

