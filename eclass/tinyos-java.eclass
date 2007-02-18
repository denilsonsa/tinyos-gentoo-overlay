
# uses java
inherit java-pkg-2

EXPORT_FUNCTIONS pkg_setup src_install
#DEPEND=">=dev-java/ibm-jdk-bin-1.4.0"
#RDEPEND=">=dev-java/ibm-jdk-bin-1.4.0"
# should lookup config files for this 
TOSDIR=/usr/src/tinyos-1.x/tos
TOSROOT=/usr/src/tinyos-1.x

NESCPATH=/usr/lib/ncc/
PATH=$PATH:$NESCPATH

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"

IUSE="source"

# tinyos needs an ibm vm with javacomm this may change in the futre
# and most probably with tinyos > 2
JAVA_PKG_FORCE_VM=ibm-jdk-1.5 
#JAVA_PKG_WANT_TARGET=ibm-jdk-1.5

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools/java

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
	ejavac    ${TOS_JAVA_SOURCESFILES} || die "Failed to compile"	

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
}

src_install() {
	debug-print-function ${FUNCNAME} $*
	java-pkg_dojar ${PN}.jar
	if [[ -f  ${TOS_PKG_JAVA_DIR}/README ]]; then 
		dodoc ${TOS_PKG_JAVA_DIR}/README
	fi
	if ! [[ -z  ${TOS_JAVA_LAUNCHER} ]]; then 
		if [[ -f  ${FILESDIR}/${TOS_JAVA_LAUNCHER}  ]]; then 
			dobin ${FILESDIR}/${TOS_JAVA_LAUNCHER}
		else
			java-pkg_dolauncher ${TOS_JAVA_LAUNCHER} --main ${TOS_JAVA_LAUNCHER_MAIN}
		fi					
	fi
	use source && java-pkg_dosrc ${TOS_PKG_JAVA_DIR}
}
