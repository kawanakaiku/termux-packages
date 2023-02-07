TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Library to organize the user work in separate activities."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kactivities/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=43a550b4e757c50942baec59499c440b2be05cc0ce47aec883112c635ed0afd6
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtdeclarative, kconfig, kcoreaddons, kwindowsystem"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, boost, boost-headers"

termux_step_pre_configure() {
    # /data/data/com.termux/files/usr/include/boost/container/new_allocator.hpp:168:12: error: '__cpp_sized_deallocation' is not defined, evaluates to 0 [-Werror,-Wundef]
    # # if __cpp_sized_deallocation
    CXXFLAGS+=" -D__cpp_sized_deallocation=0"
}
