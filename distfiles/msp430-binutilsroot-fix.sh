#!/bin/bash 

# this script is used to create links in /usr/msp430/bin to the
# binutils executables in the old fahshioned way ...
# this is needed for <gcc-3.4 to build properly ...

ESELECT_DATA_PATH="/usr/share/eselect/"
ESELECT_CORE_PATH="${ESELECT_DATA_PATH}/libs"
source "${ESELECT_CORE_PATH}/core.bash" || exit 255


BINUTILS="ar c++filt nm objdump readelf strings addr2line as ld objcopy ranlib size strip"
TARGET=msp430
SYSROOTDIR=/usr/${TARGET}


inherit config package-manager

mkdir -p ${SYSROOTDIR}/bin 


for util in ${BINUTILS} ; do 
	if [[ -h ${SYSROOTDIR}/bin/${util} || ! -e ${SYSROOTDIR}/bin/${util} ]] ; then 
		rm -f  ${SYSROOTDIR}/bin/${util}
		ln -s /usr/bin/${TARGET}-${util} ${SYSROOTDIR}/bin/${util}
	else
		echo "hum ...  ${SYSROOTDIR}/bin/${util} isn't a symlink aborting opration " ;
	fi
done 




LDSCRIPTS_BASE=/usr/lib64/binutils/${TARGET}
current=$(load_config ${ROOT}/etc/env.d/binutils/config-${TARGET} CURRENT)
echo "for target ${TARGET} binutils version "  $current

mkdir -p /usr/msp430/lib/msp2/ 
mkdir -p /usr/msp430/lib/msp1/
rm -f /usr/msp430/lib/msp2/ldscripts  /usr/msp430/lib/msp1/ldscripts 

ln -s ${LDSCRIPTS_BASE}/${current}/ldscripts /usr/msp430/lib/msp2
ln -s ${LDSCRIPTS_BASE}/${current}/ldscripts /usr/msp430/lib/msp1

echo "links created : "
ls -als  /usr/msp430/lib/msp2/ldscripts
ls -als  /usr/msp430/lib/msp1/ldscripts
