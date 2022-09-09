TERMUX_PKG_HOMEPAGE=http://www.libreoffice.org/
TERMUX_PKG_DESCRIPTION="office productivity suite"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=1
TERMUX_PKG_SRCURL=https://github.com/LibreOffice/core.git
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-android-ndk=$NDK
--with-android-sdk=$ANDROID_HOME
"

termux_step_get_source() {
	git clone --depth=1 --recurse-submodules --shallow-submodules $TERMUX_PKG_SRCURL $TERMUX_PKG_SRCDIR
}

termux_step_pre_configure() {
	aclocal -I $TERMUX_PKG_SRCDIR/m4
	autoconf -I $TERMUX_PKG_SRCDIR
}
