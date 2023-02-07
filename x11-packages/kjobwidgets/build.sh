TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Widgets for tracking KJob instances"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kjobwidgets/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=902fbb21295bb6324b0f04a4541f7166c9c5296c1cf66d48fdd0619686a43fbb
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtx11extras, kcoreaddons, kwidgetsaddons"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
"

termux_step_post_get_source() {
    sed -i -e 's/ANDROID/ANDROID_NO_TERMUX/' CMakeLists.txt
}
