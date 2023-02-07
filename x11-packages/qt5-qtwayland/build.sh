TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="QtWayland client library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.15.8
TERMUX_PKG_SRCURL=https://download.qt.io/official_releases/qt/5.15/${TERMUX_PKG_VERSION}/submodules/qtwayland-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fa0e7bd40f5da2d30fbdb51a436c5776950d6bd070b61a8d62d85cb537934529
TERMUX_PKG_DEPENDS="qt5-qtbase, libwayland"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true

# Ignore the bootstrap library that is touched by the hijack
TERMUX_PKG_RM_AFTER_INSTALL="
opt/qt/cross/lib/libQt5Bootstrap.*
"

# sudo apt install qtwayland5-dev-tools for /usr/lib/qt5/bin/qtwaylandscanner

termux_step_pre_configure() {
    #######################################################
    ##
    ##  Hijack the bootstrap library
    ##
    #######################################################
    for i in Bootstrap; do
        cp -p "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a.bak"
        ln -s -f "${TERMUX_PREFIX}/lib/libQt5${i}.a" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a"
        cp -p "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl.bak"
        ln -s -f "${TERMUX_PREFIX}/lib/libQt5${i}.prl" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl"
    done
    unset i

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
}

termux_step_configure() {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		QT_TOOL.qtwaylandscanner.binary=/usr/lib/qt5/bin/qtwaylandscanner
}

_termux_step_make_install() {
    #######################################################
    ##
    ##  Compiling necessary programs for target.
    ##
    #######################################################
    for i in client; do
        cd "${TERMUX_PKG_SRCDIR}/src/${i}" && {
            "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
                -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"

            make -j "${TERMUX_MAKE_PROCESSES}"
        }
    done
    unset i
}

termux_step_post_make_install() {
    #######################################################
    ##
    ##  Restore the bootstrap library
    ##
    #######################################################
    for i in Bootstrap; do
        mv "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a.bak" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a"
        mv "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl.bak" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl"
    done

	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
}
