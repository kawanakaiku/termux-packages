TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="KDE window manager"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.26.90
TERMUX_PKG_SRCURL=https://github.com/KDE/kwin/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2a426052a281d5bee5b4c3314a27c852b0cbd1f33d58fd98508913b0e803eaae
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qttools, qt5-qtx11extras, libxcvt, libxcb, kauth, kconfig, kconfigwidgets, kcoreaddons, kcrash, kdbusaddons, kglobalaccel, ki18n, kidletime, kpackage, plasma-framework, kwidgetsaddons, kwindowsystem, kcmutils, knewstuff"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DQTWAYLANDSCANNER_KDE_EXECUTABLE=/usr/lib/qt5/bin/qtwaylandscanner"
