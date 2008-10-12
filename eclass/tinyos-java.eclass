# Eclass for TinyOS Java packages
#
# Copyright (c) 2007-2008 Aur�lien Francillon <aurelien.francillon@inrialpes.fr>
# Copyright (c) 2008 Sandro Bonazzola <sandro.bonazzola@gmail.com>
# Copyright (c) 2007-2008 Gentoo Foundation
#
# Licensed under the GNU General Public License, v2
# $Header: $

# Original Author: Aur�lien Francillon <aurelien.francillon@inrialpes.fr>
# Purpose: helper functions for tinyos java ebuilds
# Contributors: Sandro Bonazzola <sandro.bonazzola@gmail.com>

# -----------------------------------------------------------------------------
# @eclass-begin
# @eclass-summary Eclass for TinyOS Java Packages
# @eclass-maintainer aurelien.francillon@inrialpes.fr
# @eclass-maintainer sandro.bonazzola@gmail.com
#
# This eclass should be inherited for pure Java TinyOS packages, or by packages
# which need to use Java.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @section-begin variables
# @section-title Variables
#
# Summary of variables which control the behavior of building Java packges.
# -----------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @JAVA_PKG_IUSE
#
# For creating a tarball of sourcecode
#
# ------------------------------------------------------------------------------
JAVA_PKG_IUSE="${JAVA_PKG_IUSE:=source}"

inherit tinyos java-pkg-2 java-utils-2

EXPORT_FUNCTIONS pkg_setup src_install src_compile

# -----------------------------------------------------------------------------
# @variable-external JAVA_PKG_FORCE_VM
#
# Explicitly set a particular VM to use. If its not valid, it'll fall back to
# whatever /etc/java-config-2/build/jdk.conf would elect to use.
#
# TinyOS needs an ibm vm with javacomm. This may change in the future
# and most probably with tinyos > 2
#
# @example Use ibm-jdk-1.6 to emerge foo
#	JAVA_PKG_FORCE_VM=ibm-jdk-1.6 emerge foo
#
# -----------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# @S
#
# Path of the java stuff under TinyOS
#
# ------------------------------------------------------------------------------
S="${S}/tools/java"

# -----------------------------------------------------------------------------
# @section-end variables
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @section-begin setup
# @section-summary Setup functions
#
# These are used to setup TinyOS Java-related things.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @ebuild-function tinyos_check_tosenv
#
# Checks for poroper settings of TOSROOT and TOSDIR
#
# @example
#	tinyos_check_tosenv
# ------------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# @ebuild-function tinyos_check_vm
#
# Checks for IBM JDK >= 1.4.0 with javacomm enabled.
#
# @example
#	tinyos_check_tosenv
# ------------------------------------------------------------------------------
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
	if ! [[ "${vendor}" = "ibm" ]]; then
		eerror "IBM JDK is required!"
		eerror "Please use JAVA_PKG_FORCE_VM=ibm-jdk-bin-x.y to set your system vm to the most recent IBM JDK."
		die "setup failed due to missing prerequisite: ibm jdk"
	fi
}

# -----------------------------------------------------------------------------
# @section-end setup
# -----------------------------------------------------------------------------


tos_java_build_source(){
	debug-print-function ${FUNCNAME} $*
	#einfo "TOS_PKG_JAVA_DIR set to ${TOS_PKG_JAVA_DIR}"
	if [[ -z "${TOS_PKG_JAVA_DIR}" ]]; then
		eerror  "TOS_PKG_JAVA_DIR needs to be set "
		die "fix the ebuild"
	fi
	einfo "Building $PN from source"
	if [[ -z "${TOS_JAVA_SOURCESFILES}" ]]; then
		TOS_JAVA_SOURCESFILES=`find "${TOS_PKG_JAVA_DIR}" -name "*.java"`
	fi
	einfo "building files :  ${TOS_JAVA_SOURCESFILES} "
	ejavac "${TOS_JAVA_SOURCESFILES}" || die "Failed to compile"

}

tos_java_create_jar() {
	debug-print-function ${FUNCNAME} $*
	#einfo "TOS_PKG_JAVA_DIR set to ${TOS_PKG_JAVA_DIR}"
	if [[ -z "${TOS_PKG_JAVA_DIR}" ]]; then
		eerror  "TOS_PKG_JAVA_DIR needs to be set "
		die "fix the ebuild"
	fi
	einfo "making ${PN}.jar from class files in ${TOS_PKG_JAVA_DIR} "
	find "${TOS_PKG_JAVA_DIR}" -name "*.class" | xargs jar cf "${PN}.jar"
}

pkg_setup() {
	debug-print-function ${FUNCNAME} $*
	tinyos_check_vm
	tinyos_check_tosenv
}

src_install() {
	debug-print-function ${FUNCNAME} $*
	java-pkg_dojar "${PN}.jar"
	if [[ -f "${TOS_PKG_JAVA_DIR}/README" ]]; then
		dodoc "${TOS_PKG_JAVA_DIR}/README"
	fi
	if [[ -f "${TOS_PKG_JAVA_DIR}/TODO" ]]; then
		dodoc "${TOS_PKG_JAVA_DIR}/TODO"
	fi

	for LAUNCHER in ${TOS_JAVA_LAUNCHER}; do
		if ! [[ -z "${LAUNCHER}" ]]; then
			if [[ -f "${FILESDIR}/${LAUNCHER}" ]]; then
				dobin "${FILESDIR}/${LAUNCHER}"
			else
				java-pkg_dolauncher "${LAUNCHER}" --main "${TOS_JAVA_LAUNCHER_MAIN}"
			fi
		fi
	done
	use source && java-pkg_dosrc "${TOS_PKG_JAVA_DIR}"
}

src_compile() {
	tos_java_build_source
	tos_java_create_jar
}
