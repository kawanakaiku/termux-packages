TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="process launcher to speed up launching KDE applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kinit/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=97c9207068c18a5c33e1f57657bacd4f7f6d24128b85c664b50da8ccf49ccdf4
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, kservice, kio"
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
