TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="library for system monitoring"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=16c1e4ac11ffb0545eaab0852047fa396f94fffb
_COMMIT_DATE=2023.02.03
TERMUX_PKG_VERSION=5.21.5p${_COMMIT_DATE//./}
#TERMUX_PKG_SRCURL=https://github.com/KDE/ksysguard/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
#TERMUX_PKG_SHA256=d3abe8a981fb7d4666cb2694dac29730d7dd6102161aac60a1e9745b1c324bd4
TERMUX_PKG_SRCURL=git+https://github.com/KDE/ksysguard
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, kconfig, kcoreaddons, kdbusaddons, kdoctools, ki18n, kiconthemes, kinit, kitemviews, kio, knewstuff, knotifications, solid, kwindowsystem"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$_COMMIT_DATE" ]; then
		echo -n "ERROR: The specified commit date \"$_COMMIT_DATE\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	git submodule update --init --recursive
}

_termux_step_pre_configure() {
    cp -r ksysguardd/{GNU,Android}
}
