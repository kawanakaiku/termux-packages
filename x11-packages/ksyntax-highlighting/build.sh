TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Syntax highlighting Engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/syntax-highlighting/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2a4d246f570784e3f264bdc995c3869c491f14bac0104e7e39587a3b583e37e9
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qttools"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKATEHIGHLIGHTINGINDEXER_EXECUTABLE=/usr/bin/true
"

termux_step_pre_configure() {
	# FIXME katehighlightingindexer
	mkdir $TERMUX_PKG_BUILDDIR/data
	touch $TERMUX_PKG_BUILDDIR/data/index.katesyntax
}
