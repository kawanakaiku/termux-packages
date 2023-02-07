TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="ThreadWeaver library to help multithreaded programming in Qt"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/threadweaver/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fb7c23c9e109219efa0e3f94cc48705603fe8c2fe7d6fc104ae637b137e62ce2
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

termux_step_pre_configure() {
    CXXFLAGS+=" -DQ_OS_ANDROID"
}
