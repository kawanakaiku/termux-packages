TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="library to provide information about idle time"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kidletime/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e43fd35f07cbeeeaf23d10cf66de4e1c488d4f534302dc27a6686982ed3c6bbd
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtx11extras"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKF_IGNORE_PLATFORM_CHECK=true
-DQtWaylandScanner_EXECUTABLE=/usr/lib/qt5/bin/qtwaylandscanner
"
