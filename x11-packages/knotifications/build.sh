TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Framework for desktop Framework for desktop notifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/knotifications/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d16206c15c0afe9c185d7586090de0050494e9e1fb612207e47bc15962d367d2
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtx11extras, kconfig, kcoreaddons, kwindowsystem, phonon"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
"

termux_step_post_get_source() {
    sed -i -e 's/ANDROID/ANDROID_NO_TERMUX/' CMakeLists.txt src/CMakeLists.txt
}
