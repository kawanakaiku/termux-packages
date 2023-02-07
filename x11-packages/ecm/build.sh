TERMUX_PKG_HOMEPAGE=https://gitlab.inria.fr/zimmerma/ecm
TERMUX_PKG_DESCRIPTION="factor integers using the Elliptic Curve Method"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.0.5
TERMUX_PKG_SRCURL=https://gitlab.inria.fr/zimmerma/ecm/-/archive/git-$TERMUX_PKG_VERSION/ecm-git-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=2eac2f5e73ac6b30abb99bb5c3d509e2e7a6a223318205291687ad2b873f773e
TERMUX_PKG_DEPENDS="libgmp"

termux_step_pre_configure() {
	autoreconf -fi
}
