TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Secure and unified container for user passwords."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kwallet/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6937d407292037d8357acbc1a06ad780aa1a3f9904b54607383740dfe2e7c244
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, libqca, libgcrypt, kcoreaddons, kconfig, kwindowsystem, ki18n, kconfigwidgets, kdbusaddons, knotifications, kservice"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKF_IGNORE_PLATFORM_CHECK=true"

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
