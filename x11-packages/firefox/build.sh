TERMUX_PKG_HOMEPAGE=https://packages.ubuntu.com/impish/firefox
TERMUX_PKG_DESCRIPTION="Safe and easy web browser from Mozilla"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=104.0+build3
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/main/f/firefox/firefox_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=2fca320b537741ee0307c3a4e8535e8782a299049691aa3571e15707d3582f21
TERMUX_PKG_DEPENDS="at-spi2-atk, libcairo, dbus, dbus-glib, libffi, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, pango, libx11, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxrandr, libxrender, libxtst"
#TERMUX_PKG_BUILD_IN_SRC=true

_termux_step_post_get_source() {
	sed -i -e '/android-ndk.configure/d' build/moz.configure/toolchain.configure
	sed -i -e '/extra_toolchain_flags,$/d' -e '/stlport_cppflags,$/d' -e '/android_platform,$/d' build/moz.configure/compilers-util.configure build/moz.configure/toolchain.configure
}

termux_step_pre_configure() {
	unset RUSTFLAGS
	
	find "$TERMUX_PKG_SRCDIR" -name '*.configure' | \
		xargs -n 1 sed -i \
		-e 's|\([^_]\)target\.os|\1"Linux"|g'
}

termux_step_configure() {
	python3 $TERMUX_PKG_SRCDIR/configure.py \
		--host=x86_64-pc-linux-gnu \
		--target=$TERMUX_HOST_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		--with-android-ndk=$NDK \
		--with-android-toolchain=$TERMUX_STANDALONE_TOOLCHAIN
}
