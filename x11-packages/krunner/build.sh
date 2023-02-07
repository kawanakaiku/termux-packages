TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Used to write plugins loaded at runtime called \"Runners\"."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/krunner/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b37e49b1a9224df64e17b7311cd20a769923a0e087f9633f23c205cb2077543b
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtdeclarative, kconfig, kcoreaddons, ki18n, threadweaver, kio, plasma-framework"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

termux_step_pre_configure() {
	CXXFLAGS+=" -I$TERMUX_PREFIX/include/QtDBus"
	LDFLAGS+=" -lQt5DBus"

	sed -i.bak -e 's/Qt5::DBus;//' $TERMUX_PREFIX/lib/cmake/KF5KIO/KF5KIOTargets.cmake
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/cmake/KF5KIO/KF5KIOTargets.cmake{.bak,}
}
