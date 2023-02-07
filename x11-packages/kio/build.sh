TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="resource and network access abstraction"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kio/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e65896f5faf9ce92c195441348873e57cf130e90a2633ca9f43661418d1cce23
TERMUX_PKG_DEPENDS="ecm, karchive, kconfig, kservice, kcoreaddons, solid, kbookmarks, kcompletion, kjobwidgets, kwindowsystem, kcrash, kdoctools, kdbusaddons, kauth, ktextwidgets, knotifications, libacl"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
"

# sudo apt install libkf5coreaddons-dev-bin for desktoptojson

termux_step_post_get_source() {
    sed -i -e 's/ANDROID/ANDROID_NO_TERMUX/' $(find -name CMakeLists.txt)
}

termux_step_pre_configure() {
	CXXFLAGS+=" -DQ_OS_ANDROID"

    _KDOCTOOLS_EXIST=false
    if test -d $TERMUX_PREFIX/lib/cmake/KF5DocTools; then
        _KDOCTOOLS_EXIST=true
        mv $TERMUX_PREFIX/lib/cmake/{,_}KF5DocTools
    fi

	mv $TERMUX_PREFIX/bin/desktoptojson{,.bak}
	ln -s /usr/bin/desktoptojson $TERMUX_PREFIX/bin/
}

termux_step_post_make_install() {
    if $_KDOCTOOLS_EXIST; then
        mv $TERMUX_PREFIX/lib/cmake/{_,}KF5DocTools
    fi

	mv $TERMUX_PREFIX/bin/desktoptojson{.bak,}
}
