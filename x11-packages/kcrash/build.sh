TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Support for application crash analysis and bug report from apps"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kcrash/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=46c1c82496af911772931aaf51f00f554dfd8e9574dcbe7fb3c8ca793369a9cb
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, kcoreaddons"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKF_IGNORE_PLATFORM_CHECK=true"
