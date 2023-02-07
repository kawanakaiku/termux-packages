TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Porting aid from KDELibs4."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kdelibs4support/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1c05e52ef8b394146120059bc2ddb82fd5defbc64596968d408f4aba1cf5b51a
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtsvg, qt5-qttools, kcompletion, kconfigwidgets, kcrash, kglobalaccel, kdoctools, kdesignerplugin, ki18n, kiconthemes, kio, kparts, kunitconversion, kded"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKF_IGNORE_PLATFORM_CHECK=true
-DHAVE_GOOD_GETADDRINFO_EXITCODE=0
-DHAVE_GOOD_GETADDRINFO_EXITCODE__TRYRUN_OUTPUT=0
"

termux_step_post_get_source() {
    # This works for some reason
    rm cmake/modules/FindGettext.cmake
}

termux_step_pre_configure() {
    _USE_HOST_MEINPROC5=false
    local f=/usr/bin/meinproc5
    if test -f $f; then
        _USE_HOST_MEINPROC5=true
        mv $TERMUX_PREFIX/bin/meinproc5{,.bak}
        ln -s $f $TERMUX_PREFIX/bin
        $TERMUX_PREFIX/bin/meinproc5
    fi

	mv $TERMUX_PREFIX/bin/desktoptojson{,.bak}
	ln -s /usr/bin/desktoptojson $TERMUX_PREFIX/bin/
}

termux_step_post_make_install() {
    if $_USE_HOST_MEINPROC5; then
        mv $TERMUX_PREFIX/bin/meinproc5{.bak,}
    fi

	mv $TERMUX_PREFIX/bin/desktoptojson{.bak,}
}
