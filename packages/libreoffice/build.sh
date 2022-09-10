TERMUX_PKG_HOMEPAGE=http://www.libreoffice.org/
TERMUX_PKG_DESCRIPTION="office productivity suite"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
_COMMIT=3c58a8f3a960df8bc8fd77b461821e42c061c5f0
TERMUX_PKG_VERSION=7.4.1.2
TERMUX_PKG_SRCURL=https://github.com/LibreOffice/core.git
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="at-spi2-atk, avahi, boost, brotli, dbus, dconf, fontconfig, freetype, fribidi, gdk-pixbuf, glib, gpgme, gpgmepp, gst-plugins-base, gstreamer, gtk3, harfbuzz, harfbuzz-icu, hunspell, libassuan, libbsd, libbz2, libcairo, libcap, libdw, libelf, libepoxy, libexpat, libffi, libgcrypt, libgmp, libgnutls, libgpg-error, libgraphite, libgrpc, libhyphen, libice, libicu, libidn2, libjpeg-turbo, libltdl, liblz4, liblzma, libmd, libmhash, libnettle, libnghttp2, libnspr, libnss, liborc, libpixman, libpng, libpsl, libraptor2, librasqal, libsasl, libsm, libssh, libtasn1, libunistring, libuuid, libwayland, libx11, libxau, libxcb, libxcomposite, libxcursor, libxdamage, libxdmcp, libxext, libxfixes, libxi, libxinerama, libxkbcommon, libxml2, libxrandr, libxrender, libxslt, libxt, littlecms, mesa, openjpeg, openldap, openssl, p11-kit, pango, pcre, pcre2, python, rtmpdump, util-linux, xmlsec, yajl, zlib, zstd"

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PYTHON_CFLAGS=-I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}
PYTHON_LIBS=-lpython${_PYTHON_VERSION}
--with-jdk-home=${JAVA_HOME}
JAVAINC=-I${TERMUX_PREFIX}/opt/openjdk/include
"

_termux_step_get_source() {
	git clone --depth=1 --recurse-submodules --shallow-submodules $TERMUX_PKG_SRCURL $TERMUX_PKG_SRCDIR
}

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT
}

termux_step_pre_configure() {
	# for hostbuild
	export CC_FOR_BUILD=/usr/bin/gcc
	export CXX_FOR_BUILD=/usr/bin/g++
	export PKG_CONFIG_PATH=${TERMUX_PREFIX}/lib/pkgconfig
	
	export CC="${CC} ${CFLAGS}"
	export CXX="${CXX} ${CXXFLAGS}"
	export LD="${LD} ${LDFLAGS}"
	unset CFLAGS CXXFLAGS LDFLAGS
	
	# patch configure
	sed -i -e 's|unset CC CXX SYSBASE CFLAGS|unset CC CXX SYSBASE CFLAGS CXXFLAGS LDFLAGS|' configure.ac
	sed -i -e 's%linux-gnu\*|k\*bsd\*-gnu\*|linux-musl\*%linux-gnu*|k*bsd*-gnu*|linux-musl*|linux-android*%' configure.ac

	# install host dependencies
	(
	unset sudo
	sudo apt-get update
	sudo apt-get install -y --no-install-recommends git build-essential zip ccache junit4 libkrb5-dev nasm graphviz python3 python3-dev qtbase5-dev libkf5coreaddons-dev libkf5i18n-dev libkf5config-dev libkf5windowsystem-dev libkf5kio-dev autoconf libcups2-dev libfontconfig1-dev gperf doxygen libxslt1-dev xsltproc libxml2-utils libxrandr-dev libx11-dev bison flex libgtk-3-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev ant ant-optional libnss3-dev libavahi-client-dev libxt-dev
	)
	
	aclocal -I $TERMUX_PKG_SRCDIR/m4
	autoconf -I $TERMUX_PKG_SRCDIR
	
	# cc1: error: argument to ‘-O’ should be a non-negative integer, ‘g’, ‘s’ or ‘fast’
	#CFLAGS="${CFLAGS/-Oz/-Os}"
	#CXXFLAGS="${CXXFLAGS/-Oz/-Os}"
	# gcc: error: unrecognized command-line option ‘-static-openmp’
	#LDFLAGS="${LDFLAGS/-static-openmp/}"
	
	# nss.pc does not exist (3.78-1)
	export NSS_CFLAGS="-I${TERMUX_PREFIX}/include/nspr"
	export NSS_LIBS="-L${TERMUX_PREFIX}/lib -lnss3 -lnssutil3 -lsmime3 -lssl3"
	
	# checking for cupsPrintFiles in -lcups... no
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	--enable-cups=no
	"
	
	# configure: error: could not find function 'com_err' required for Kerberos 5
	# configure: error: could not find function 'gss_init_sec_context' required for GSSAPI
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	--with-krb5=no
        --with-gssapi=no
	"
	
	no_not_found() {
		sed -i -e "s|$1=no|$1=yes|g" configure
	}
	# configure: error: X Development libraries not found
	no_not_found c_cv_lib_X11_XOpenDisplay
	# configure: error: ICE library not found
	no_not_found ac_cv_lib_ICE_IceConnectionNumber
	# configure: error: SM library not found
	no_not_found ac_cv_lib_SM_SmcOpenConnection
	# configure: error: libXrender not found or functional
	no_not_found ac_cv_lib_Xrender_XRenderQueryVersion
	# configure: error: libGL required.
	no_not_found ac_cv_lib_GL_glBegin
}
