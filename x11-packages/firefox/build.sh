TERMUX_PKG_HOMEPAGE=https://packages.ubuntu.com/impish/firefox
TERMUX_PKG_DESCRIPTION="Safe and easy web browser from Mozilla"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=104.0+build3
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/main/f/firefox/firefox_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=2fca320b537741ee0307c3a4e8535e8782a299049691aa3571e15707d3582f21
TERMUX_PKG_DEPENDS="libandroid-sysv-semaphore, at-spi2-atk, libcairo, dbus, dbus-glib, libffi, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, pango, libice, libsm, libx11, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxrandr, libxrender, libxtst"
#TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	#sed -i -e 's|"Android",|"Android","_NO_TERMUX_",|' python/mozbuild/mozbuild/configure/constants.py
	#sed -i 's/\(target = help_host_target | real_target\)/\1\ntarget.os = "Linux"/' build/moz.configure/init.configure
	#xargs -n 1 sed -i -e 's|"Android"|"_NO_TERMUX_Android"|g' build/moz.configure/toolchain.configure
	#sed -i -e 's|"Android"|"_NO_TERMUX_"|g' $( grep -rl --include '*.configure' -e '"Android"' "$TERMUX_PKG_SRCDIR" )
	#sed -i -e 's|\([^_]\)target.os == "Android"|\1False|g' -e 's|\([^_]\)target.os != "Android"|\1True|g' $( grep -rl --include '*.configure' -e '"Android"' "$TERMUX_PKG_SRCDIR" )
	#sed -i -e '/=arm_option_defaults\./d' build/moz.configure/arm.configure
	
	sed -i -e 's|canonical_os = "Android"|canonical_os = "GNU"|' build/moz.configure/init.configure
	
	sed -i -e 's|die(|log.error("preventing to die: ",|' toolkit/moz.configure build/moz.configure/rust.configure
	
	sed -i -e 's|default=dmd_default,|default=False,|' toolkit/moz.configure  # 152
	sed -i -e 's|alsa_enabled or midir_linux_support|False|' toolkit/moz.configure  # 326
	sed -i -e 's|is_android and not debug and not is_nightly|True|' toolkit/moz.configure  # 863
	sed -i -e 's|default=mozilla_official,|default=False,|' toolkit/moz.configure  # 959
	sed -i -e 's|reporting and is_nightly|False|' toolkit/moz.configure  # 971
	sed -i -e 's|default=webspeech,|default=False,|' toolkit/moz.configure  # 1096
	sed -i -e 's|return milestone\.is_nightly|return False|' toolkit/moz.configure  # 1113 1677
	sed -i -e 's|default=geckodriver_default,|default=False,|' toolkit/moz.configure  # 1259
	sed -i -e 's|milestone\.is_esr|True|' toolkit/moz.configure  # 1626 1662
	sed -i -e 's|if debug:|if False:|' toolkit/moz.configure  # 1810 1831
	sed -i -e 's|if milestone\.is_nightly:|if False:|' toolkit/moz.configure  # 2538 2552
	sed -i -e 's|default=target_is_android,|default=False,|' toolkit/moz.configure  # 2683
	sed -i -e 's|default=crashreporter_default,|default=False,|' toolkit/moz.configure  # 2844
	sed -i -e 's|default=moz_debug,|default=False,|' toolkit/moz.configure  # 2978
	sed -i -e 's|default=sandbox_default,|default=False,|' toolkit/moz.configure  # 3026
	
	termux_setup_rust
	
	#unset RUSTFLAGS
	cargo install --target x86_64-unknown-linux-gnu cbindgen
	
	termux_setup_nodejs
	
	export PKG_CONFIG=$TERMUX_STANDALONE_TOOLCHAIN/bin/pkg-config
	
	sed -i -e 's|if sysroot.path:|if False:|' build/moz.configure/toolchain.configure
	sed -i -e 's|\$target|__no_termux__|' build/autoconf/android.m4
	#sed -i -e 's|flags = flags or \[\]|flags = flags or []; flags = flags + os.getenv("CFLAGS", "").split() + os.getenv("CXXFLAGS", "").split() + os.getenv("LDFLAGS", "").split()|' build/moz.configure/util.configure
	export HOST_CC=gcc
	export HOST_CXX=g++
	export HOST_LD=ld
	
	# File listed in FINAL_TARGET_FILES does not exist: /home/builder/.termux-build/firefox/src/toolkit/mozapps/update/tests/data/complete.exe
	sed -i -e '/\.exe",$/d' toolkit/mozapps/update/tests/moz.build
	
	# /home/builder/.termux-build/firefox/src/nsprpub/pr/src/pthreads/ptsynch.c:960:7: error: redefinition of 'semun'
	sed -i -e 's|defined(DARWIN)|defined(__ANDROID__)|' nsprpub/pr/src/pthreads/ptsynch.c
	
	# failed to open file `/home/builder/.termux-build/firefox/src/third_party/rust/libloading/tests/nagisa32.dll`
	sed -i -E 's|,"[a-z0-9/]+\.dll":"[a-z0-9]+"||g' third_party/rust/libloading/.cargo-checksum.json
	
	# mozbuild.configure.options.InvalidOptionError: * takes 1 value
	sed -i -e "s|rustc_target = find_candidate(candidates)|rustc_target = '$CARGO_TARGET_NAME'|" build/moz.configure/rust.configure
	sed -i -e '/RUSTFLAGS/d' build/moz.configure/rust.configure
	
	#error[E0432]: unresolved imports `backend::MidiInputPort`, `backend::MidiInput`, `backend::MidiInputConnection`, `backend::MidiOutputPort`, `backend::MidiOutput`, `backend::MidiOutputConnection`
	echo > third_party/rust/midir/src/common.rs
	sed -i -e "s|2cab2e987428522ca601544b516b64b858859730fbd1be0e53c828e82025319d|$( sha256sum third_party/rust/midir/src/common.rs )|" third_party/rust/libloading/.cargo-checksum.json
}

termux_step_configure() {
	#export MOZBUILD_STATE_PATH=$TERMUX_PKG_BUILDDIR/.mozbuild
	#yes 1 | $TERMUX_PKG_SRCDIR/mach bootstrap
	
	# fatal error: 'glib-object.h' file not found
	# ( for i in libandroid-sysv-semaphore at-spi2-atk libcairo dbus dbus-glib libffi fontconfig freetype gdk-pixbuf glib gtk3 harfbuzz pango libice libsm libx11 libxcb libxcomposite libxcursor libxdamage libxext libxfixes libxi libxrandr libxrender libxtst; do apt-file show $i; done ) | grep '\.pc$' | awk '{print $2}' | xargs -n1 basename | sed 's|\.pc$||' | xargs pkg-config --cflags
	# ( for i in libandroid-sysv-semaphore at-spi2-atk libcairo dbus dbus-glib libffi fontconfig freetype gdk-pixbuf glib gtk3 harfbuzz pango libice libsm libx11 libxcb libxcomposite libxcursor libxdamage libxext libxfixes libxi libxrandr libxrender libxtst; do apt-file show $i; done ) | grep '\.pc$' | awk '{print $2}' | xargs -n1 basename | sed 's|\.pc$||' | xargs pkg-config --libs
	TARGET_CFLAGS+=" -pthread -I/data/data/com.termux/files/usr/include/at-spi2-atk/2.0 -I/data/data/com.termux/files/usr/include/at-spi-2.0 -I/data/data/com.termux/files/usr/include/cairo -I/data/data/com.termux/files/usr/include/dbus-1.0 -I/data/data/com.termux/files/usr/lib/dbus-1.0/include -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/gail-3.0 -I/data/data/com.termux/files/usr/include/gtk-3.0 -I/data/data/com.termux/files/usr/include/gtk-3.0/unix-print -I/data/data/com.termux/files/usr/include/gtk-3.0 -I/data/data/com.termux/files/usr/include/gio-unix-2.0 -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/cairo -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/atk-1.0 -I/data/data/com.termux/files/usr/include/cairo -I/data/data/com.termux/files/usr/include/gdk-pixbuf-2.0 -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/harfbuzz -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/harfbuzz -I/data/data/com.termux/files/usr/include/pango-1.0 -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/fribidi -I/data/data/com.termux/files/usr/include/cairo -I/data/data/com.termux/files/usr/include/pixman-1 -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/harfbuzz -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/glib-2.0 -I/data/data/com.termux/files/usr/lib/glib-2.0/include -I/data/data/com.termux/files/usr/include -I/data/data/com.termux/files/usr/include/libxml2 -I/data/data/com.termux/files/usr/include/freetype2 -I/data/data/com.termux/files/usr/include/libpng16 -I/data/data/com.termux/files/usr/include "
	LDFLAGS+=" -L/data/data/com.termux/files/usr/lib -latk-bridge-2.0 -latspi -lz -lpng16 -lz -ldbus-glib-1 -ldbus-1 -lffi -Wl,--export-dynamic -lgmodule-2.0 -pthread -lgthread-2.0 -pthread -lgailutil-3 -lgdk-3 -lgtk-3 -lgdk-3 -latk-1.0 -lcairo-gobject -lgdk_pixbuf-2.0 -lgio-2.0 -lharfbuzz-gobject -lharfbuzz-icu -lharfbuzz-subset -lpangocairo-1.0 -lcairo -lpangoxft-1.0 -lpangoft2-1.0 -lpango-1.0 -lgobject-2.0 -lglib-2.0 -lharfbuzz -lfontconfig -lfreetype -lXft -lICE -lSM -lX11-xcb -lxcb-composite -lxcb-damage -lxcb-dpms -lxcb-dri2 -lxcb-dri3 -lxcb-glx -lxcb-present -lxcb-randr -lxcb-record -lxcb-render -lxcb-res -lxcb-screensaver -lxcb-shape -lxcb-shm -lxcb-sync -lxcb-xf86dri -lxcb-xfixes -lxcb-xinerama -lxcb-xinput -lxcb-xkb -lxcb-xtest -lxcb-xv -lxcb-xvmc -lxcb -lXcomposite -lXcursor -lXdamage -lXext -lXfixes -lXi -lXrandr -lXrender -lX11 -lXtst "
	
	echo env start
	env | sort
	echo env end

	PATH="$(
		bindir=/tmp/bin
		mkdir -p $bindir
		for var in CC CXX LD; do
			EXE=$( eval "echo \$$var" )
			ABS=$( which $EXE )
			NEW=$bindir/$EXE
			case $var in
				C* ) FLAGS="$TARGET_CFLAGS" ;;
				LD ) FLAGS="$LDFLAGS" ;;
			esac
			cat <<-SH >$NEW
			#!/usr/bin/sh
			exec $ABS $FLAGS "\$@"
			SH
			chmod +x $NEW
		done
		echo $bindir
	):$PATH"
	unset TARGET_CFLAGS LDFLAGS
	
	python3 $TERMUX_PKG_SRCDIR/configure.py \
		--host=x86_64-pc-linux-gnu \
		--target=$TERMUX_HOST_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		--with-sysroot=$TERMUX_PREFIX \
		 \
		--enable-audio-backends=aaudio,opensl \
		--enable-minify=properties,js \
		--without-wasm-sandboxed-libraries
}
