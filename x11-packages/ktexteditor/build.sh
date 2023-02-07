TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="provide advanced plain text editing services"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/ktexteditor/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c677068619edcc7855851e31121431b1813b530417d91c5cea91f8fc02ed20a8
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtdeclarative, karchive, kconfig, kguiaddons, kio, kparts, ksyntax-highlighting"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKSERVICETYPE_PATH_kpart.desktop=$TERMUX_PREFIX/share/kservicetypes5/kpart.desktop
"

termux_step_pre_configure() {
	sed -i.bak -e 's/Qt5::DBus;//' $TERMUX_PREFIX/lib/cmake/KF5KIO/KF5KIOTargets.cmake

	mv $TERMUX_PREFIX/bin/desktoptojson{,.bak}
	ln -s /usr/bin/desktoptojson $TERMUX_PREFIX/bin/
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/cmake/KF5KIO/KF5KIOTargets.cmake{.bak,}

	mv $TERMUX_PREFIX/bin/desktoptojson{.bak,}
}
