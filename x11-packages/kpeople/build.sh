TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="framework providing unified access to contacts aggregated by person"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kpeople/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=faf4f39f282b4c87db438fc3c30ebcd0bd2cbecc8817f7ed96833d316d410bd6
#TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtx11extras"
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qttools, kcoreaddons, kwidgetsaddons, ki18n, kitemviews"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
#TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKF_IGNORE_PLATFORM_CHECK=true"
