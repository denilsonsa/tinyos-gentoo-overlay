# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils tinyos-java

DESCRIPTION="Utility classes for TinyOS java applictions"
LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 ~x86"
DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jdk-1.4
	|| ( >=dev-tinyos/tos-getenv-1.1.15
         >=dev-tinyos/tinyos-tools-1.2.3)"

TOS_PKG_JAVA_DIR="net/tinyos/util"

