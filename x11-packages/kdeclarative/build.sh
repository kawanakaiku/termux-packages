TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="provides integration of QML and KDE frameworks"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kdeclarative/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=95d22122b06ef170e9d5593c91fabbdcb42cf693001adf25af85ff35c879fc2e
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtdeclarative, kconfig, ki18n, kiconthemes, kio, kpackage, kglobalaccel, knotifications"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

# sudo apt install libkf5config-dev-bin for kconfig

termux_step_pre_configure() {
	CXXFLAGS+=" -DQ_OS_ANDROID"

    local f=/usr/lib/libexec/kf5/kconfig_compiler_kf5
    if ! test -f $f; then
        echo "$f doesn't exist."
        return 1
    fi
    mv $TERMUX_PREFIX/lib/libexec/kf5/kconfig_compiler_kf5{,.bak}
    ln -s $f $TERMUX_PREFIX/lib/libexec/kf5/kconfig_compiler_kf5
}

termux_step_post_make_install() {
    mv $TERMUX_PREFIX/lib/libexec/kf5/kconfig_compiler_kf5{.bak,}
}
