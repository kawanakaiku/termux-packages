TERMUX_PKG_HOMEPAGE=https://www.winehq.org/
TERMUX_PKG_DESCRIPTION="WINE Is Not An Emulator - runs MS Windows programs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION_LIST=(
3.0.4	e48489b67763321a20e69bc1ef691904b9c94583066f0b4f155718f04cc281c4
4.0.4	665e4e6a4ce8474da551c5bf4511d4ffd81702a598d2882c38b9e4f9d3e14e0c
5.0.5	e1c97716788a7865232f87853a5c860e3d9d06de815500d30449c9326c5204f8
6.0.4	ca50376e3f7200493214daa5f7fd1145bfc9dd085c4814e4d502d4723e7b52a6
7.16	ba3002fd2520e3b7250aba127a8da682a07a7dc8919d3791a9a60448ffc2de06
)
TERMUX_PKG_VERSION_INDEX=3
TERMUX_PKG_VERSION=${TERMUX_PKG_VERSION_LIST[$((TERMUX_PKG_VERSION_INDEX*2))]}
TERMUX_PKG_SHA256=${TERMUX_PKG_VERSION_LIST[$((TERMUX_PKG_VERSION_INDEX*2+1))]}
TERMUX_PKG_SRCURL=https://github.com/wine-mirror/wine/archive/refs/tags/wine-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-shmem, dbus, fontconfig, freetype, libgnutls, libjpeg-turbo, libpng, libtiff, mesa, glu, libx11, libxcomposite, libxcursor, libxfixes, libxinerama, libxi, libxml2, libxslt"
#TERMUX_PKG_BUILD_DEPENDS=""
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
--enable-win64 --with-freetype --with-gettext --disable-tests --disable-win16 --without-alsa --without-capi --without-cms --without-coreaudio --without-cups --without-curses --without-dbus --without-fontconfig --without-gphoto --without-glu --without-gnutls --without-gsm --without-gstreamer --without-hal --without-jpeg --without-krb5 --without-ldap --without-mpg123 --without-netapi --without-openal --without-opencl --without-opengl --without-osmesa --without-oss --without-pcap --without-pulse --without-png --without-sane --without-tiff --without-v4l --without-x --without-xcomposite --without-xcursor --without-xinerama --without-xinput --without-xinput2 --without-xml --without-xrandr --without-xrender --without-xshape --without-xshm --without-xslt --without-xxf86vm --without-zlib
"
# https://wiki.winehq.org/Building_Wine
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-wine-tools=${TERMUX_PKG_HOSTBUILD_DIR}
--without-pulse
--with-dbus
--with-fontconfig
--with-freetype
--with-gnutls
--with-jpeg
--with-png
--with-tiff
--with-opengl
--with-glu
--without-unwind
--with-x
--with-xcomposite
--with-xcursor
--with-xfixes
--with-xinerama
--with-xinput
--with-xml
--with-xslt
--disable-tests
enable_wineandroid_drv=no
"

termux_step_host_build() {
	(
		unset sudo
		sudo apt-get update
		sudo apt-get install -y --no-install-recommends libfreetype-dev
	)
	
	# ld.lld: error: unknown argument '--no-wchar-size-warning'
	sed -i -E 's|,?--no-wchar-size-warning||' "${i}" tools/winebuild/utils.c tools/winegcc/winegcc.c

	"$TERMUX_PKG_SRCDIR/configure" ${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	make -j "$TERMUX_MAKE_PROCESSES" __tooldeps__
}

termux_step_pre_configure() {
	(
		# winebuild: cannot find the 'as' tool
		winebuild=${TERMUX_PKG_HOSTBUILD_DIR}/tools/winebuild/winebuild
		mv ${winebuild} ${winebuild}_
		cat <<-SH >${winebuild}
		#!/usr/bin/sh
		exec ${winebuild}_ --as-cmd=$(which llvm-as) --cc-cmd=$(which $CC) --ld-cmd=$(which $LD) --nm-cmd=$(which llvm-nm) "\$@"
		SH
		chmod +x ${winebuild}
	)
	
	case $TERMUX_PKG_VERSION in
		5.0.5 )
			;;
		6.0.4 )
			# /home/builder/.termux-build/wine/src/dlls/ws2_32/socket.c:1986:24: error: invalid application of 'sizeof' to an incomplete type 'struct sockaddr_ipx'
			# /home/builder/.termux-build/wine/src/server/sock.c:228:25: error: field has incomplete type 'struct sockaddr_ipx'
			sed -i -e 's|define HAS_IPX|define _disbale_HAS_IPX|' dlls/ws2_32/socket.c server/sock.c
			
			# ld: error: undefined symbol: pthread_mutexattr_setprotocol
			# LDFLAGS+=" -pthread"
			# add --without-pulse
			
			# ld: error: undefined symbol: libandroid_shmget
			# ld: error: undefined symbol: libandroid_shmat
			# ld: error: undefined symbol: libandroid_shmctl
			# ld: error: undefined symbol: libandroid_shmdt
			LDFLAGS+=" -landroid-shmem"
			;;

		7.16 )
			# winebuild: cannot find the 'dlltool' tool
			;;
	esac
}
