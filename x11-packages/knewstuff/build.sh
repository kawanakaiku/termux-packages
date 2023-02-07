TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Support for downloading application assets from the network."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/knewstuff/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=009c53510677a498b7b91689c177e4777ec1c6df87b73b5adfb3032b0d3ad166
#complete
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, karchive, kcompletion, kconfig, kcoreaddons, ki18n, kiconthemes, kio, kitemviews, kpackage, kservice, ktextwidgets, kwidgetsaddons, kxmlgui, attica"
TERMUX_PKG_RECOMMENDS="kirigami2"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

termux_step_pre_configure() {
	sed -i.bak -e 's/Qt5::DBus;//' $TERMUX_PREFIX/lib/cmake/KF5KIO/KF5KIOTargets.cmake
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/cmake/KF5KIO/KF5KIOTargets.cmake{.bak,}
}
