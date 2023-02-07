TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="development files for the Qt Cryptographic Architecture"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.5
TERMUX_PKG_SRCURL=https://github.com/KDE/qca/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=326346893c5ad41c160b66ff10740ff4d8a1cbcd2fe545693f9791de1e01f00b
#TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, kcoreaddons, kconfig, kwindowsystem, ki18n, kconfigwidgets, kdbusaddons, knotifications, kservice"
TERMUX_PKG_DEPENDS="qt5-qtbase"
#TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
#TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKF_IGNORE_PLATFORM_CHECK=true"

termux_step_pre_configure() {
    CXXFLAGS+=" -DQ_OS_ANDROID"
}
