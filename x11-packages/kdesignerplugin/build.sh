TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Porting aid from KDELibs4."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kdesignerplugin/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a565daf668e24b71358edddb117c51f23d7dafd979edd28edcd74afb1fca94b1
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, kcoreaddons, kconfig, kemoticons"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKF_IGNORE_PLATFORM_CHECK=true"
_TERMUX_PKG_RM_AFTER_INSTALL="bin/*"

termux_step_pre_configure() {
    _USE_HOST_MEINPROC5=false
    local f=/usr/bin/meinproc5
    if test -f $f; then
        _USE_HOST_MEINPROC5=true
        mv $TERMUX_PREFIX/bin/meinproc5{,.bak}
        ln -s $f $TERMUX_PREFIX/bin
        $TERMUX_PREFIX/bin/meinproc5
    fi
}

termux_step_post_make_install() {
    if $_USE_HOST_MEINPROC5; then
        mv $TERMUX_PREFIX/bin/meinproc5{.bak,}
    fi
}
