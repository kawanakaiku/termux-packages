TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Extra widgets for easier configuration support."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kconfigwidgets/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c4c51c09d5835d3cdc6e0a36e2271154349f04cca3d0ad9f3fd3743d16cec29e
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, kcoreaddons, kcodecs, kconfig, kguiaddons, ki18n, kwidgetsaddons"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

termux_step_pre_configure() {
    _KDOCTOOLS_EXIST=false
    if test -d $TERMUX_PREFIX/lib/cmake/KF5DocTools; then
        _KDOCTOOLS_EXIST=true
        mv $TERMUX_PREFIX/lib/cmake/{,_}KF5DocTools
    fi
}

termux_step_post_make_install() {
    if $_KDOCTOOLS_EXIST; then
        mv $TERMUX_PREFIX/lib/cmake/{_,}KF5DocTools
    fi
}
