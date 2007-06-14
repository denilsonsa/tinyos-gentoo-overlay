#!/bin/bash 
# this script builds tar.gz distfiles against a cvs tagged version of tinyos 

# Makes a new release of tinyos 

## config verion tags here 
DATE=`date +"%Y%m%d"`

TINYOS_VERSION=2.0.1
PATCHLEVEL=${DATE}
TINYOS_RELEASE=
TINYOS_TOOLS_VERSION=1.2.3
TINYOS_TOOLS_PATCHLEVEL=${DATE}
TINYOS_TOOLS_RELEASE=
#CVSTAG=release_tinyos_2_0_1

# verion of the ebuilds to take as base ...
BASE_PVR=2.0.1_p20070607
TINYOS_BASE_PNR=tinyos-${BASE_PVR}
TOS_BASE_PNR=tos-${BASE_PVR}
TOS_SDK_JAVA_BASE_PNR=tos-sdk-java-${BASE_PVR}
TOS_SDK_PYTHON_BASE_PNR=tos-sdk-python-${BASE_PVR}
TOS_SDK_C_BASE_PNR=tos-sdk-c-${BASE_PVR}
TINYOS_TOOLS_BASE_PNR=tinyos-tools-1.2.3_p20070607




HOME=/home/francill/
# some debugging facilities ...
#CVS_DONT_UPDATE=yes
#SCP_DONT_TRANSFER=yes
# config path's here 
#CVSDIR=${HOME}/work/sensors/tinyos/tinyos-sources/cvs/tinyos-2.x
CVSDIR=${HOME}/cvstrees/tinyos/tinyos-2.x
RELEASE_TOOLS=${CVSDIR}/tools/release
WORKDIR=${HOME}/tmp/
OVERLAYDIR=${HOME}/portageoverlays/tinyos-2-overlay
#don't change after here ... 
ORIG_PWD=`pwd`


# generate packages versioned names 
PV=${TINYOS_VERSION}
if [ ! -z  ${PATCHLEVEL} ]; then 
    PV=${PV}_p${PATCHLEVEL}
fi

PN=tinyos-${PV}
DOCS_PN=tinyos-docs-${PV}

PVR=${PV}
PNR=tinyos-${PV}
DOCS_PNR=tinyos-docs-${PV}

if [ ! -z  ${TINYOS_RELEASE} ]; then 
    PVR=${PV}-r${TINYOS_RELEASE}
	PNR=tinyos-${PVR}
	DOCS_PNR=tinyos-docs-${PVR}
fi 


TOOLS_PV=${TINYOS_TOOLS_VERSION}
if [ ! -z  ${TINYOS_TOOLS_PATCHLEVEL} ]; then 
    TOOLS_PV=${TOOLS_PV}_p${PATCHLEVEL}
fi

TOOLS_PN=tinyos-tools-${TOOLS_PV}

if [ ! -z  ${TINYOS_TOOLS_RELEASE} ]; then 
    TOOLS_PVR=${PV}-r${TINYOS_TOOLS_RELEASE}
	TOOLS_PNR=tinyos-tools-${TOOLS_PVR}
else
	TOOLS_PNR=tinyos-tools-${TOOLS_PV}
fi 

echo "will generate packages for tinyos version ${PNR} and tools ${TOOLS_PNR} ... "
echo " hit enter to continue "
read 




if [[ "yes" != "${CVS_DONT_UPDATE}" ]] ; then 
#cvs update and smash local changes 
	cd ${CVSDIR}
	
	if [ ! -z ${CVSTAG} ]; then  
		echo "cvs update  -CPd -r ${CVSTAG}"
		cvs update  -CPd -r ${CVSTAG}
	else 
		if [ ! -z ${PATCHLEVEL} ]; then 
			echo "cvs update  -CPd -D ${PATCHLEVEL}"
			cvs update  -CPd -D ${PATCHLEVEL}
		else  # getting head 
			echo "cvs update  -CPd"
			cvs update  -CPd 
		fi 
	fi 
fi
cd ${CVSDIR}/tools/release/

echo "*** Building tarball for ${PN}"
#fixing version 
sed -i "s|VERSION=.*|VERSION=${PV}|" ${CVSDIR}/tools/release/tinyos.files
bash tinyos.files
#mv ${CVSDIR}/../${PNR}.tar.gz ${ORIG_PWD}/

echo "*** Building tarball for ${TOOLS_PN}"
sed -i "s|VERSION=.*|VERSION=${TOOLS_PV}|" ${CVSDIR}/tools/release/tinyos-tools.files
sh tinyos-tools.files
#mv ${TOOLS_PNR}.tar.gz ${ORIG_PWD}/


echo "*** building tarball for tinyos-docs-$PN"  
cd ${CVSDIR}
cp -a doc $DOCS_PNR
tar --exclude 'CVS' -zcf ${DOCS_PNR}.tar.gz ${DOCS_PNR}
mv ${DOCS_PNR}.tar.gz ${CVSDIR}/../
rm -rf ${CVSDIR}/${DOCS_PNR}

cd ${ORIG_PWD}


#mv tinyos-${TINYOS_VERSION}.tar.gz  tinyos-$PV.tar.gz 
#mv tinyos-tools-${TINYOS_TOOLS_VERSION}.tar.gz  tinyos-tools-$TOOLS_PV.tar.gz 

if [[ "yes" != ${SCP_DONT_TRANSFER} ]] ; then 
	echo "copy files to web sever ... "
	scp ${CVSDIR}/../{$PNR,$TOOLS_PNR,$DOCS_PNR}.tar.gz  aurel@naurel.org:/var/www/localhost/htdocs/stuff
fi 

## updating ebuilds 


cp ${OVERLAYDIR}/dev-tinyos/tinyos/${TINYOS_BASE_PNR}.ebuild\
	${OVERLAYDIR}/dev-tinyos/tinyos/${PNR}.ebuild 

cp ${OVERLAYDIR}/dev-tinyos/tos/${TOS_BASE_PNR}.ebuild\
	${OVERLAYDIR}/dev-tinyos/tos/tos-${PVR}.ebuild 

cp ${OVERLAYDIR}/dev-tinyos/tinyos-tools/${TINYOS_TOOLS_BASE_PNR}.ebuild\
	${OVERLAYDIR}/dev-tinyos/tinyos-tools/${TOOLS_PNR}.ebuild 

cp ${OVERLAYDIR}/dev-tinyos/tos-sdk-c/${TOS_SDK_C_BASE_PNR}.ebuild\
	${OVERLAYDIR}/dev-tinyos/tos-sdk-c/tos-sdk-c-${PVR}.ebuild 

cp ${OVERLAYDIR}/dev-tinyos/tos-sdk-java/${TOS_SDK_JAVA_BASE_PNR}.ebuild\
	${OVERLAYDIR}/dev-tinyos/tos-sdk-java/tos-sdk-java-${PVR}.ebuild 

cp ${OVERLAYDIR}/dev-tinyos/tos-sdk-python/${TOS_SDK_PYTHON_BASE_PNR}.ebuild\
	${OVERLAYDIR}/dev-tinyos/tos-sdk-python/tos-sdk-python-${PVR}.ebuild 

cp ${OVERLAYDIR}/dev-tinyos/tinyos-docs/tinyos-docs-${BASE_PVR}.ebuild\
	${OVERLAYDIR}/dev-tinyos/tinyos-docs/tinyos-docs-${PVR}.ebuild 


echo "generating digests "

for  i in tos-sdk-python/tos-sdk-python-${PVR}.ebuild  \
	tos-sdk-java/tos-sdk-java-${PVR}.ebuild   \
    tos-sdk-c/tos-sdk-c-${PVR}.ebuild  \
    tinyos-tools/${TOOLS_PNR}.ebuild \
    tinyos-docs/tinyos-docs-${PVR}.ebuild \
    tos/tos-${PVR}.ebuild \
    tinyos/${PNR}.ebuild ; do 
  ebuild ${OVERLAYDIR}/dev-tinyos/${i} digest 
done 


echo "to use the newly generated packages add :" 
echo "=dev-tinyos/${PNR}"
echo "=dev-tinyos/tos-${PVR}"
echo "=dev-tinyos/${TOOLS_PNR}"
echo "=dev-tinyos/tinyos-docs-${PVR}"
echo "=dev-tinyos/tos-sdk-c-${PVR}"
echo "=dev-tinyos/tos-sdk-java-${PVR}"
echo "=dev-tinyos/tos-sdk-python-${PVR}"


