TERMUX_PKG_HOMEPAGE=https://www.winehq.org/
TERMUX_PKG_DESCRIPTION="WINE Is Not An Emulator - runs MS Windows programs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION_LIST=(
7.16
6.0.4
5.0.5
4.0.4
3.0.4
)
TERMUX_PKG_SHA256_LIST=(
ba3002fd2520e3b7250aba127a8da682a07a7dc8919d3791a9a60448ffc2de06
ca50376e3f7200493214daa5f7fd1145bfc9dd085c4814e4d502d4723e7b52a6
e1c97716788a7865232f87853a5c860e3d9d06de815500d30449c9326c5204f8
665e4e6a4ce8474da551c5bf4511d4ffd81702a598d2882c38b9e4f9d3e14e0c
e48489b67763321a20e69bc1ef691904b9c94583066f0b4f155718f04cc281c4
)
TERMUX_PKG_VERSION_INDEX=2
TERMUX_PKG_VERSION=${TERMUX_PKG_VERSION_LIST[$TERMUX_PKG_VERSION_INDEX]}
TERMUX_PKG_SHA256=${TERMUX_PKG_SHA256_LIST[$TERMUX_PKG_VERSION_INDEX]}
TERMUX_PKG_SRCURL=https://github.com/wine-mirror/wine/archive/refs/tags/wine-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="freetype, libpng, libx11"
#TERMUX_PKG_BUILD_DEPENDS=""
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--enable-win64 --without-freetype --without-gettext --disable-tests --disable-win16 --without-alsa --without-capi --without-cms --without-coreaudio --without-cups --without-curses --without-dbus --without-fontconfig --without-gphoto --without-glu --without-gnutls --without-gsm --without-gstreamer --without-hal --without-jpeg --without-krb5 --without-ldap --without-mpg123 --without-netapi --without-openal --without-opencl --without-opengl --without-osmesa --without-oss --without-pcap --without-pulse --without-png --without-sane --without-tiff --without-v4l --without-x --without-xcomposite --without-xcursor --without-xinerama --without-xinput --without-xinput2 --without-xml --without-xrandr --without-xrender --without-xshape --without-xshm --without-xslt --without-xxf86vm --without-zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
enable_wineandroid_drv=no
--with-wine-tools=${TERMUX_PKG_HOSTBUILD_DIR}
--with-freetype
--with-png
--with-x
--disable-tests
"

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR/configure" ${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	make -j "$TERMUX_MAKE_PROCESSES" __tooldeps__
}

termux_step_pre_configure() {
	case $TERMUX_PKG_VERSION in
	5.0.5 )
		# winebuild: cannot find the 'as' tool
		echo symlinking as
		(
			exe="$(which llvm-as)"
			_bin="$(dirname "$exe")"
			ln -s llvm-as "$_bin/as"
		)
		which -a as
		;;
	6.0.6 )
		# /home/builder/.termux-build/wine/src/dlls/ws2_32/socket.c:1986:24: error: invalid application of 'sizeof' to an incomplete type 'struct sockaddr_ipx'
		;;
	
	7.16 )
		# winebuild: cannot find the 'dlltool' tool
		;;
	esac
}
