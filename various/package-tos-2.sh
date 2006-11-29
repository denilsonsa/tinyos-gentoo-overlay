#!/bin/sh
# this script builds tar.gz distfiles against a cvs tagged version of tinyos 


TINYOS_VERSION=2.0.0
TINYOS_RELEASE=3
TINYOS_TOOLS_VERSION=1.2.3
CVSTAG=tinyos-2-0-0-3-rpm



CVSDIR=/home/francill/work/sensors/tinyos/tinyos-sources/cvs/tinyos-2.x
RELEASE_TOOLS=${CVSDIR}/tools/release
WORKDIR=/home/francill/tmp/
PV=${TINYOS_VERSION}-r${TINYOS_RELEASE}
PN=tinyos-${PV}

ORIG_PWD=`pwd`

TOOLS_PV=${TINYOS_TOOLS_VERSION}
TOOLS_PN=tinyos-tools-${TINYOS_TOOLS_VERSION}

DOCS_PN=tinyos-docs-${PV}

# cvs update and smash local changes 
cd ${CVSDIR}
echo "cvs update  -CPd -r ${CVSTAG}"
#cvs update  -CPd -r ${CVSTAG}
cd ${ORIG_PWD}

cd ${CVSDIR}/tools/release/
echo "*** Building tarballs for ${PN}"

# fixing version 
sed -i "s|VERSION=.*|VERSION=${PV}|" ${CVSDIR}/tools/release/tinyos.files
sh tinyos.files


echo "*** Building tarball for  ${TOOLS_PN}"
sed -i "s|VERSION=.*|VERSION=${TOOLS_PV}|" ${CVSDIR}/tools/release/tinyos-tools.files
sh tinyos-tools.files


echo "*** building tarball for tinyos-docs-$PV"  

cd ${CVSDIR}
cp -a doc tinyos-docs-$PV
tar --exclude 'CVS' -zcf tinyos-docs-$PV.tar.gz tinyos-docs-$PV
mv tinyos-docs-$PV.tar.gz ${ORIG_PWD}/
rm -rf ${CVSDIR}/tinyos-docs-$PV

cd ${ORIG_PWD}


#mv tinyos-${TINYOS_VERSION}.tar.gz  tinyos-$PV.tar.gz 
#mv tinyos-tools-${TINYOS_TOOLS_VERSION}.tar.gz  tinyos-tools-$TOOLS_PV.tar.gz 



scp {$PN,$TOOLS_PN,$DOCS_PN}.tar.gz  aurel@naurel.org:/var/www/localhost/htdocs/stuff
