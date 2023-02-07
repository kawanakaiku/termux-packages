TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Widgets with advanced auto-completion features."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kcompletion/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f6ac2d5d02532a6222f4c0274e74cfd9eab27c630087e7fe1636e865297a0dc6
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, kconfig, kwidgetsaddons"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
