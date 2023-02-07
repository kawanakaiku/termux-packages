TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Document centric plugin system."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kparts/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fdf89ff0570ea157f8eaa1446cb0bb3380674843dcc667390f85e13545baef73
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, sonnet, kconfig, kcoreaddons, ki18n, kiconthemes, kio"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

termux_step_pre_configure() {
    CXXFLAGS+=" -DQ_OS_ANDROID"

	sed -i.bak -e 's/Qt5::DBus;//' $TERMUX_PREFIX/lib/cmake/KF5KIO/KF5KIOTargets.cmake
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/cmake/KF5KIO/KF5KIOTargets.cmake{.bak,}
}
