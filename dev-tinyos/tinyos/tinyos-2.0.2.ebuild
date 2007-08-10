# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="TinyOS: merge this to pull in all TinyOS packages"
HOMEPAGE="http://www.tinyos.net/"
SRC_URI=""
LICENSE="Intel"
SLOT="2"
KEYWORDS="amd64 ~x86"
IUSE="java python"

RDEPEND=">=dev-tinyos/nesc-1.2.7a
	dev-tinyos/eselect-tinyos
	>=dev-tinyos/tos-2.0.2
	java? ( >=dev-tinyos/tos-sdk-java-2.0.2 )
	python? ( >=dev-tinyos/tos-sdk-python-2.0.2 )
	>=dev-tinyos/tinyos-tools-1.2.4
	>=dev-tinyos/tos-sdk-c-2.0.2"

