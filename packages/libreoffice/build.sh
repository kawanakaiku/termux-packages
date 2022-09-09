TERMUX_PKG_HOMEPAGE=http://www.libreoffice.org/
TERMUX_PKG_DESCRIPTION="office productivity suite"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=1
TERMUX_PKG_SRCURL=https://github.com/LibreOffice/core.git
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="at-spi2-atk, avahi, boost, brotli, cups, dbus, dconf, fontconfig, freetype, fribidi, gdk-pixbuf, glib, gpgme, gpgmepp, gst-plugins-base, gstreamer, gtk3, harfbuzz, harfbuzz-icu, hunspell, krb5, libassuan, libbsd, libbz2, libcairo, libcap, libdw, libelf, libepoxy, libexpat, libffi, libgcrypt, libgmp, libgnutls, libgpg-error, libgraphite, libgrpc, libhyphen, libice, libicu, libidn2, libjpeg-turbo, libltdl, liblz4, liblzma, libmd, libmhash, libnettle, libnghttp2, libnspr, libnss, liborc, libpixman, libpng, libpsl, libraptor2, librasqal, libsasl, libsm, libssh, libtasn1, libunistring, libuuid, libwayland, libx11, libxau, libxcb, libxcomposite, libxcursor, libxdamage, libxdmcp, libxext, libxfixes, libxi, libxinerama, libxkbcommon, libxml2, libxrandr, libxrender, libxslt, littlecms, openjpeg, openldap, openssl, p11-kit, pango, pcre, pcre2, python, rtmpdump, util-linux, xmlsec, yajl, zlib, zstd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-android-ndk=$NDK
--with-android-sdk=$ANDROID_HOME
"

termux_step_get_source() {
	git clone --depth=1 --recurse-submodules --shallow-submodules $TERMUX_PKG_SRCURL $TERMUX_PKG_SRCDIR
}

termux_step_pre_configure() {
	# hostbuild
	export CC_FOR_BUILD=/usr/bin/gcc
	export CXX_FOR_BUILD=/usr/bin/g++
	export PKG_CONFIG_FOR_BUILD=/usr/bin/pkg-config
	# patch configure
	sed -i -e 's|unset CC CXX SYSBASE CFLAGS|unset CC CXX SYSBASE CFLAGS CXXFLAGS LDFLAGS|' configure.ac
	# install host dependencies
	(
	unset sudo
	sudo apt-get update
	sudo apt-get install -y --no-install-recommends git build-essential zip ccache junit4 libkrb5-dev nasm graphviz python3 python3-dev qtbase5-dev libkf5coreaddons-dev libkf5i18n-dev libkf5config-dev libkf5windowsystem-dev libkf5kio-dev autoconf libcups2-dev libfontconfig1-dev gperf default-jdk doxygen libxslt1-dev xsltproc libxml2-utils libxrandr-dev libx11-dev bison flex libgtk-3-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev ant ant-optional libnss3-dev libavahi-client-dev libxt-dev
	)
	
	aclocal -I $TERMUX_PKG_SRCDIR/m4
	autoconf -I $TERMUX_PKG_SRCDIR
}
