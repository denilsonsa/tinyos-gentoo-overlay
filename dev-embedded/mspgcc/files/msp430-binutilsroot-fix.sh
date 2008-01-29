#!/bin/bash 

#DEBUG=true
DEBUG=false 

[[ -z ${ROOT} ]] && ROOT="/"
[[ ${ROOT} != */ ]] && ROOT="${ROOT}/"
[[ ${ROOT} != /* ]] && ROOT="${PWD}${ROOT}"


# this script is used to create links in /usr/msp430/bin to the
# binutils executables in the old fahshioned way ...
# this is needed for <gcc-3.4 to build properly ...


[[ -z ${MERGEROOT} ]] && MERGEROOT=${ROOT}

ESELECT_DATA_PATH="/usr/share/eselect/"
ESELECT_CORE_PATH="${ESELECT_DATA_PATH}/libs"
source "${ESELECT_CORE_PATH}/core.bash" || exit 255

inherit config package-manager 


BINUTILS="ar c++filt nm objdump readelf strings addr2line as ld objcopy ranlib size strip"
TARGET=msp430
SYSROOTDIR=${MERGEROOT}/usr/${TARGET}




function list_sys_root {
    if [[ "true" =  "${DEBUG}" ]] ; then  
	echo "ls -las ${SYSROOTDIR}"
	ls -las ${SYSROOTDIR}
	echo "ls -las ${SYSROOTDIR}/bin"
	ls -las ${SYSROOTDIR}/bin
	echo "ls -las ${SYSROOTDIR}/lib"
	ls -las ${SYSROOTDIR}/lib
    fi
}

function clean_up_previous_links {
    #cleanup previous links to binutils    
    for util in ${BINUTILS} ; do 
	if [[ -h ${SYSROOTDIR}/bin/${util} ]] ; then 
	    rm -f ${SYSROOTDIR}/bin/${util}
	fi
    done 
    
    #cleanup previous links to ldscripts   
    rm -f ${ROOT}/usr/msp430/lib/msp2/ldscripts  ${MERGEROOT}/usr/msp430/lib/msp1/ldscripts 
}

function create_binutils_links {
    # creating binutils tools links to /usr/msp43 
    for util in ${BINUTILS} ; do 
	if [[ ! -e ${SYSROOTDIR}/bin/${util} ]] ; then 
	    ln -s /usr/bin/${TARGET}-${util} ${SYSROOTDIR}/bin/${util}
	else
	    echo "hum ...  ${SYSROOTDIR}/bin/${util} isn't a symlink aborting opration " ;
	    return 
	fi
    done 
}

function Create_libc_links {

    # amd64 host 
    LDSCRIPTS_BASE=${ROOT}/usr/lib64/binutils/${TARGET}
    # x86 host 
    if [ ! -f ${LDSCRIPTS_BASE} ] ; then
	LDSCRIPTS_BASE=${ROOT}/usr/lib/binutils/${TARGET}
    fi
    
    # get binutils current version 
    current=$(load_config ${ROOT}/etc/env.d/binutils/config-${TARGET} CURRENT)
    echo "for target ${TARGET} binutils version "  $current
    
    # creating dirs 
    mkdir -p ${ROOT}/usr/msp430/lib/msp2/ 
    mkdir -p ${ROOT}/usr/msp430/lib/msp1/

    # create links from /usr/msp430/lib/msp... to /usr/lib64/binutils/
    ln -s ${LDSCRIPTS_BASE}/${current}/ldscripts ${MERGEROOT}/usr/msp430/lib/msp2
    ln -s ${LDSCRIPTS_BASE}/${current}/ldscripts ${MERGEROOT}/usr/msp430/lib/msp1
}

## Main
mkdir -p ${SYSROOTDIR}/bin 
echo "cleaning up "
clean_up_previous_links
list_sys_root 

echo "creating binutlis links  "
create_binutils_links
list_sys_root 

echo "creating msp430 libc links to /usr/msp430/lib "
Create_libc_links 
echo "Done"
list_sys_root 


#done 
if [[ "true" =  "${DEBUG}" ]] ;  then 
    list_sys_root 
    
    echo "ldscripts  links created : "
    ls -als  ${ROOT}/usr/msp430/lib/msp2/ldscripts
    ls -als  ${ROOT}/usr/msp430/lib/msp1/ldscripts
fi
