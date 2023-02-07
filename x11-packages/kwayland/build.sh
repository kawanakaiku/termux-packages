TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Qt library wrapper for Wayland libraries"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kwayland/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ddb50d900013e3f96c934144d565fd3cbeba6fcf47f70f9ba32479c9a749397c
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtwayland, plasma-wayland-protocols, wayland-protocols"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQtWaylandScanner_EXECUTABLE=/usr/lib/qt5/bin/qtwaylandscanner
"

termux_step_post_get_source() {
    # src/server/drm_fourcc.h:16:18: error: typedef redefinition with different types ('uint64_t' (aka 'unsigned long') vs 'unsigned long long')
    # typedef uint64_t __u64;
    # android-r25c-api-24-v0/sysroot/usr/include/asm-generic/int-ll64.h:31:42: note: previous definition is here
    # __extension__ typedef unsigned long long __u64;
    sed -i \
        -e '/typedef uint32_t __u32;/d' \
        -e '/typedef uint64_t __u64;/d' \
        src/server/drm_fourcc.h
}
