#!/bin/sh
# this script builds tar.gz distfiles against a cvs tagged version of tinyos 


## config verion tags here 

TINYOS_VERSION=2.0.1
TINYOS_RELEASE=
TINYOS_TOOLS_VERSION=1.2.3
CVSTAG=release_tinyos_2_0_1


# config path's here 
#CVSDIR=/home/francill/work/sensors/tinyos/tinyos-sources/cvs/tinyos-2.x
CVSDIR=/home/francill/cvstrees/tinyos/tinyos-2.x
RELEASE_TOOLS=${CVSDIR}/tools/release
WORKDIR=/home/francill/tmp/

#don't change after here ... 
PV=${TINYOS_VERSION}

if [ ! -n  ${TINYOS_RELEASE} ]; then 
    PV=${PV}-r${TINYOS_RELEASE}
fi
PN=tinyos-${PV}

ORIG_PWD=`pwd`

TOOLS_PV=${TINYOS_TOOLS_VERSION}
TOOLS_PN=tinyos-tools-${TINYOS_TOOLS_VERSION}

DOCS_PN=tinyos-docs-${PV}

#cvs update and smash local changes 
cd ${CVSDIR}
echo "cvs update  -CPd -r ${CVSTAG}"
cvs update  -CPd -r ${CVSTAG}
cd ${ORIG_PWD}

cd ${CVSDIR}/tools/release/

echo "*** Building tarball for ${PN}"
#fixing version 
sed -i "s|VERSION=.*|VERSION=${PV}|" ${CVSDIR}/tools/release/tinyos.files
bash -x tinyos.files

echo "*** Building tarball for ${TOOLS_PN}"
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
