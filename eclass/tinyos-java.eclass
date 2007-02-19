# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Original Author: Aurélien Francillon <aurelien.francillon@inrialpes.fr>
# Purpose: helper functions for tinyos java ebuilds  


# uses java
inherit tinyos java-pkg-2

EXPORT_FUNCTIONS pkg_setup src_install src_compile

# To create a tarball of sourcecode   
IUSE="source"

# tinyos needs an ibm vm with javacomm this may change in the futre
# and most probably with tinyos > 2
JAVA_PKG_FORCE_VM=ibm-jdk-1.5 
#JAVA_PKG_WANT_TARGET=ibm-jdk-1.5


# path of the java stuff 
S=${S}/tools/java


# checks for poroper settings of TOSROOT and TOSDIR
tinyos_check_tosenv() {
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
}


tinyos_check_vm() {
	debug-print-function ${FUNCNAME} $*
	if ! built_with_use dev-java/ibm-jdk-bin javacomm ; then
		eerror "javacomm is required! Add javacomm to your use flag then re-emerge ibm-jdk-bin."
		eerror "Then re-emerge this package."
		die "setup failed due to missing prerequisite: javacomm"
	fi


	java-pkg-2_pkg_setup
	java-pkg_ensure-vm-version-ge 1 4 0
	local vendor=`java-pkg_get-vm-vendor`
	#einfo "${vendor} vm detected."
	if ! [[ ${vendor} = "ibm" ]]; then
		eerror "ibm vm is required!"
		eerror "Please use java-config -S to set your system vm to a ibm."
		die "setup failed due to missing prerequisite: ibm jdk"
	fi
}

tos_java_build_source(){
	debug-print-function ${FUNCNAME} $*
	#einfo "TOS_PKG_JAVA_DIR set to ${TOS_PKG_JAVA_DIR}" 
	if [[ -z  ${TOS_PKG_JAVA_DIR} ]]; then 
		eerror  "TOS_PKG_JAVA_DIR needs to be set "
		die "fix the ebuild"
	fi
	einfo "Building $PN from source"
	if [[ -z ${TOS_JAVA_SOURCESFILES} ]]; then 
		TOS_JAVA_SOURCESFILES=`find ${TOS_PKG_JAVA_DIR} -name "*.java"`
	fi 
	einfo "building files :  ${TOS_JAVA_SOURCESFILES} "
	ejavac   ${TOS_JAVA_SOURCESFILES} || die "Failed to compile"	

}

tos_java_create_jar() {	
	debug-print-function ${FUNCNAME} $*
	#einfo "TOS_PKG_JAVA_DIR set to ${TOS_PKG_JAVA_DIR}" 
	if [[ -z  ${TOS_PKG_JAVA_DIR} ]]; then 
		eerror  "TOS_PKG_JAVA_DIR needs to be set "
		die "fix the ebuild"
	fi
	einfo "making ${PN}.jar from class files in ${TOS_PKG_JAVA_DIR} "
	find ${TOS_PKG_JAVA_DIR} -name "*.class" | xargs jar cf ${PN}.jar
}

pkg_setup() {
	debug-print-function ${FUNCNAME} $*
	tinyos_check_vm
	tinyos_check_tosenv
}

src_install() {
	debug-print-function ${FUNCNAME} $*
	java-pkg_dojar ${PN}.jar
	if [[ -f  ${TOS_PKG_JAVA_DIR}/README ]]; then 
		dodoc ${TOS_PKG_JAVA_DIR}/README
	fi
	if [[ -f  ${TOS_PKG_JAVA_DIR}/TODO ]]; then 
		dodoc ${TOS_PKG_JAVA_DIR}/TODO
	fi

	for LAUNCHER in ${TOS_JAVA_LAUNCHER}; do 
		if ! [[ -z  ${LAUNCHER} ]]; then 
			if [[ -f  ${FILESDIR}/${LAUNCHER}  ]]; then 
				dobin ${FILESDIR}/${LAUNCHER}
			else
				java-pkg_dolauncher ${LAUNCHER} --main ${TOS_JAVA_LAUNCHER_MAIN}
			fi					
		fi
	done
	use source && java-pkg_dosrc ${TOS_PKG_JAVA_DIR}
}



src_compile() {
	tos_java_build_source
	tos_java_create_jar
}

