# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="TinyOS: merge this to pull in all TinyOS packages"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI=""
LICENSE="Intel"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="dev-tinyos/eselect-tinyos
    >=dev-tinyos/tos-2.0.0
	>=dev-tinyos/nesc-1.2.7a
    >=dev-tinyos/tinyos-tools-1.2.2
    !dev-embedded/uisp"
