# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Original Author: Aurélien Francillon <aurelien.francillon@inrialpes.fr>
# Purpose: standard path and URL defines for tinyos 


# should lookup config files for this 
#TOSDIR=/usr/src/tinyos-1.x/tos
#TOSROOT=/usr/src/tinyos-1.x

# Nesc installs stuff here but needs that in the path ...
NESCPATH=/usr/lib/ncc/
PATH=$PATH:$NESCPATH

# this is cvs snapshot version dependent and shoud be cahnged
# according to ${PV}
CVS_MONTH="Dec" CVS_YEAR="2005" MY_P="tinyos"

# fits all defines ...
HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs


