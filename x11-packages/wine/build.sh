TERMUX_PKG_HOMEPAGE=https://www.winehq.org/
TERMUX_PKG_DESCRIPTION="Windows API implementation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.22
TERMUX_PKG_SRCURL=https://github.com/wine-mirror/wine/archive/refs/tags/wine-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a82165bf14fbf9a318ee260fe9cfb73983ca8ad3348c0bf1fc6593d5ebdfc7e8
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="libx11, freetype, libxcursor, libxi, libxxf86vm, libxrandr, libxfixes, libxinerama, libxcomposite, osmesa, libpcap, dbus, libusb, libv4l, pulseaudio, gstreamer, gst-plugins-base, sdl2, cups, krb5, libgnutls, libandroid-shmem"
#TERMUX_MAKE_PROCESSES=1
#TERMUX_DEBUG_BUILD=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, aarch64, x86_64"

: <<'LOG'
configure: MinGW compiler not found, cross-compiling PE files won't be supported.
configure: libxcursor development files not found, the Xcursor extension won't be supported.
configure: libxi development files not found, the Xinput extension won't be supported.
configure: XShm development files not found, X Shared Memory won't be supported.
configure: XShape development files not found, XShape won't be supported.
configure: libXxf86vm development files not found, XFree86 Vidmode won't be supported.
configure: libxrandr development files not found, XRandr won't be supported.
configure: libxfixes development files not found, Xfixes won't be supported.
configure: libxinerama development files not found, multi-monitor setups won't be supported.
configure: libxcomposite development files not found, Xcomposite won't be supported.
configure: libOSMesa development files not found (or too old), OpenGL rendering in bitmaps won't be supported.
configure: OpenCL development files not found, OpenCL won't be supported.
configure: pcap development files not found, wpcap won't be supported.
configure: libdbus development files not found, no dynamic device support.
configure: libsane development files not found, scanners won't be supported.
configure: libusb-1.0 development files not found (or too old), USB devices won't be supported.
configure: libv4l2 development files not found.
configure: libgphoto2 development files not found, digital cameras won't be supported.
configure: libgphoto2_port development files not found, digital cameras won't be auto-detected.
configure: libpulse development files not found or too old, Pulse won't be supported.
configure: gstreamer-1.0 base plugins development files not found, GStreamer won't be supported.
configure: OSS sound system found but too old (OSSv4 needed), OSS won't be supported.
configure: libudev development files not found, plug and play won't be supported.
configure: libSDL2 development files not found, SDL2 won't be supported.
configure: libcapi20 development files not found, ISDN won't be supported.
configure: libcups development files not found, CUPS won't be supported.
configure: fontconfig development files not found, fontconfig won't be supported.
configure: libkrb5 development files not found (or too old), Kerberos won't be supported.
configure: libnetapi not found, Samba NetAPI won't be supported.

configure: WARNING: prelink not found and linker does not support relocation, base address of core dlls won't be set correctly.

configure: WARNING: libxrender development files not found, XRender won't be supported.

configure: WARNING: No OpenGL library found on this system.
OpenGL and Direct3D won't be supported.

configure: WARNING: libgnutls development files not found, no schannel support.

configure: WARNING: No sound system was found. Windows applications will be silent.
LOG

log_sed() {
	printf 'Applying sed substitution to %s\n' "${f[@]}"
	sed "$@" "${f[@]}"
}

termux_step_post_get_source() {
	local f
	# ld.lld: error: unknown argument '--no-wchar-size-warning'
	f=(tools/winebuild/utils.c tools/winegcc/winegcc.c)
	log_sed -i -e 's/.*--no-wchar-size-warning.*/;/'

	# ld.lld: error: relocation R_ARM_ABS32 cannot be used against symbol '__wine$func$ucrtbase$2310$memset'; recompile with -fPIC
	#f=(tools/winebuild/spec32.c)
	#log_sed -i -e 's|"\\n\\t.section \\".text\\",\\"ax\\"\\n"|"\\n\\t.section \\".init\\",\\"ax\\"\\n"|'

	rm -f $TERMUX_HOSTBUILD_MARKER
}

termux_step_host_build() {
	/usr/bin/sudo dpkg --add-architecture i386
	/usr/bin/sudo apt update
	/usr/bin/sudo apt install -y libfreetype6-dev:i386
	$TERMUX_PKG_SRCDIR/configure --without-x
	make -j $TERMUX_MAKE_PROCESSES __tooldeps__ nls/all
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	--with-wine-tools=$TERMUX_PKG_HOSTBUILD_DIR
	"
	#--disable-tests
	#enable_wineandroid_drv=no

	local f d
	# "struct sockaddr_ipx" not exist
	f=(dlls/ntdll/unix/socket.c dlls/ws2_32/unixlib.c server/sock.c)
	log_sed -i -e '/^# define HAS_IPX$/d'

	# build for linux not android
	f=(configure)
	log_sed -i -E 's/^  linux-android\*\)$/  no-termux)/'

	# ld.lld: error: cannot open crtbegin_so.o: No such file or directory
	if test $TERMUX_ARCH = arm
	then
		:
		#LDFLAGS+=" -fuse-ld=gold"
		LDFLAGS+=" -B$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL"
		#CFLAGS+=" -fPIC"
		#f=configure
		#echo "Applying sed substitution to $f"
		#sed -i -E 's|(LDDLLFLAGS="\$LDDLLFLAGS) (-fasynchronous-unwind-tables")|\1 \2|' $f
		#ln -sf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/crt{begin,end}_so.o $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/
		#TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" enable_kernelbase=no"
		#d=$TERMUX_PKG_TMPDIR/arm-dummy-lib
		#(
		#	mkdir -p $d
		#	cd $d
		#	for f in crt{begin,end}_so.c
		#	do
		#		touch $f
		#		$CC -c $f
		#		rm $f
		#	done
		#)
		#LDFLAGS+=" -B$d"
	fi

	# disable Basic hardening
	CFLAGS="${CFLAGS//-fstack-protector-strong/}"
	LDFLAGS="${LDFLAGS//-Wl,-z,relro,-z,now/}"

	# needed with libgnutls
	f=(configure)
	log_sed -i -E 's/^(UNIXLDFLAGS=")/\1 -landroid-shmem /'

	# ld: error: undefined symbol: pthread_mutexattr_setprotocol
	# needed with pulseaudio
	f=(dlls/winepulse.drv/pulse.c)
	log_sed -i -e '/pthread_mutexattr_setprotocol/d'

	# mingw
	#PATH+=":$TERMUX_COMMON_CACHEDIR/llvm-mingw-20220906-msvcrt-ubuntu-18.04-x86_64/bin"
	#TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-mingw=${TERMUX_ARCH//arm/armv7}-w64-mingw32-clang"

	if test $TERMUX_ARCH = i686 -o $TERMUX_ARCH = x86_64
	then
		/usr/bin/sudo apt install -y gcc-mingw-w64-${TERMUX_ARCH//_/-}-posix
		f=$TERMUX_ARCH-w64-mingw32-gcc
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-mingw=$f"
	fi
}
