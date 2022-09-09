TERMUX_PKG_HOMEPAGE=http://www.libreoffice.org/
TERMUX_PKG_DESCRIPTION="office productivity suite"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=1
TERMUX_PKG_SRCURL=https://github.com/LibreOffice/core.git
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libice, libsm, libx11, libxau, libxcomposite, libxcursor, libxdamage, libxdmcp, libxext, libxfixes, libxi, libxinerama, libxrandr, libxrender, libgrpc, libassuan, at-spi2-atk, avahi, util-linux, boost, brotli, libbsd, libbz2, libcairo, libcap, krb5, openssl, cups, dbus, dconf, libdw, libelf, libepoxy, libexpat, libxslt, libffi, fontconfig, freetype, fribidi, libgcrypt, gtk3, gdk-pixbuf, glib, libgmp, libgnutls, libgpg-error, gpgme, gpgmepp, libgraphite, krb5, gst-plugins-base, gstreamer, gst-plugins-base, gstreamer, gst-plugins-base, gtk3, harfbuzz-icu, harfbuzz, libnettle, hunspell, libhyphen, libicu, libidn2, libjpeg-turbo, openldap, littlecms, libltdl, liblz4, liblzma, libmd, libmhash, libnettle, libnghttp2, libnspr, libnss, openjpeg, liborc, p11-kit, pango, pango, pcre, pcre2, libpixman, libnspr, libpng, libpsl, python, libraptor2, librasqal, rtmpdump, libsasl, libnss, libssh, libtasn1, libunistring, libuuid, libwayland, libxcb, libxkbcommon, libxml2, xmlsec, libxslt, yajl, zlib, zstd"
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
	
	# hostbuild
	export CC_FOR_BUILD=/usr/bin/gcc
	export CXX_FOR_BUILD=/usr/bin/g++
	export PKG_CONFIG_FOR_BUILD=/usr/bin/pkg-config
	# patch configure
	sed -i -e 's|unset CC CXX SYSBASE CFLAGS|unset CC CXX SYSBASE CFLAGS CXXFLAGS LDFLAGS|' configure.ac
}
