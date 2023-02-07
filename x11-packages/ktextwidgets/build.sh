TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Advanced text editing widgets."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/ktextwidgets/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4f62c71c22da87f942bfc3ebb0ea1ca88ce2002c7b52f14d11430be33d89e6c8
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, kcompletion, kconfigwidgets, sonnet"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
