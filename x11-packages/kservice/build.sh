TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Advanced plugin and service introspection"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kservice/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7644ea4348a6c5ca799caa0182b14f4332ae91c0ab6717989b49c5a4deda189c
TERMUX_PKG_DEPENDS="ecm, kconfig, kcoreaddons, ki18n"
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
