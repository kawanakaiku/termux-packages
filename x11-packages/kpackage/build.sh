TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="non-binary asset management framework"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kpackage/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c6a8b9024f6e3ae7b285939475eb1019c8db3f1755d99d58f9723dec98bcb490
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, karchive, ki18n, kcoreaddons"
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
