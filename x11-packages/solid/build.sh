TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Qt library to query and control hardware"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/solid/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0af4d33ce6763abb79eef1c8bef1fe517e841d51e7965c10ff73a086090cdd5f
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qttools"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
Qt5LinguistTools_DIR=$TERMUX_PREFIX/lib/Qt5LinguistTools
"
