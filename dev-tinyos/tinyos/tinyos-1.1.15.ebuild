# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="TinyOS: merge this to pull in all TinyOS packages"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI=""
LICENSE="Intel"
SLOT="1"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="=dev-tinyos/tos-1*
	>=dev-tinyos/nesc-1.2.1
	|| ( ( >=dev-tinyos/listen-1.1.15
	       >=dev-tinyos/tos-uisp-1.1.15	
	       >=dev-tinyos/channelgen
           >=dev-tinyos/tos-getenv-1.1.15
          )>=dev-tinyos/tinyos-tools-1.2.3)
    >=dev-tinyos/serial-forwarder-1.1.15
	>=dev-tinyos/tos-make-1.1.15
	>=dev-tinyos/tos-javalibs-1.1.15
	>=dev-tinyos/tos-simdriver-1.1.15
	>=dev-tinyos/tos-plot-1.1.15"

