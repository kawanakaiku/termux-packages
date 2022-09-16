TERMUX_PKG_HOMEPAGE=https://packages.ubuntu.com/impish/firefox
TERMUX_PKG_DESCRIPTION="Safe and easy web browser from Mozilla"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=104.0+build3
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/main/f/firefox/firefox_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=2fca320b537741ee0307c3a4e8535e8782a299049691aa3571e15707d3582f21
#TERMUX_PKG_DEPENDS="at-spi2-atk, libcairo, dbus, dbus-glib, libffi, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, pango, libx11, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxrandr, libxrender, libxtst"
#TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	#sed -i -e 's|"Android",|"Android","_NO_TERMUX_",|' python/mozbuild/mozbuild/configure/constants.py
	#sed -i 's/\(target = help_host_target | real_target\)/\1\ntarget.os = "Linux"/' build/moz.configure/init.configure
	#xargs -n 1 sed -i -e 's|"Android"|"_NO_TERMUX_Android"|g' build/moz.configure/toolchain.configure
	#sed -i -e 's|"Android"|"_NO_TERMUX_"|g' $( grep -rl --include '*.configure' -e '"Android"' "$TERMUX_PKG_SRCDIR" )
	#sed -i -e 's|\([^_]\)target.os == "Android"|\1False|g' -e 's|\([^_]\)target.os != "Android"|\1True|g' $( grep -rl --include '*.configure' -e '"Android"' "$TERMUX_PKG_SRCDIR" )
	#sed -i -e '/=arm_option_defaults\./d' build/moz.configure/arm.configure
	
	sed -i -e 's|canonical_os = "Android"|canonical_os = "GNU"|' build/moz.configure/init.configure
	
	sed -i -e 's|die(|log.error("preventing to die: ",|' toolkit/moz.configure
	
	sed -i -e 's|default=dmd_default,|default=False,|' toolkit/moz.configure  # 152
	sed -i -e 's|is_android and not debug and not is_nightly|True|' toolkit/moz.configure  # 863
	sed -i -e 's|default=mozilla_official,|default=False,|' toolkit/moz.configure  # 959
	sed -i -e 's|reporting and is_nightly|False|' toolkit/moz.configure  # 971
	sed -i -e 's|default=webspeech,|default=False,|' toolkit/moz.configure  # 1096
	sed -i -e 's|return milestone\.is_nightly|return False|' toolkit/moz.configure  # 1113 1677
	sed -i -e 's|default=geckodriver_default,|default=False,|' toolkit/moz.configure  # 1259
	sed -i -e 's|milestone\.is_esr|True|' toolkit/moz.configure  # 1626 1662
	sed -i -e 's|if debug:|if False:|' toolkit/moz.configure  # 1810 1831
	sed -i -e 's|default=default_wasm_sandboxing_libraries,|default=tuple(),|' toolkit/moz.configure  # 2396
	sed -i -e 's|if milestone\.is_nightly:|if False:|' toolkit/moz.configure  # 2538 2552
	sed -i -e 's|default=target_is_android,|default=False,|' toolkit/moz.configure  # 2683
	sed -i -e 's|default=crashreporter_default,|default=False,|' toolkit/moz.configure  # 2844
	sed -i -e 's|default=moz_debug,|default=False,|' toolkit/moz.configure  # 2978
	sed -i -e 's|default=sandbox_default,|default=False,|' toolkit/moz.configure  # 3026
}

termux_step_configure() {
	unset RUSTFLAGS
	export PKG_CONFIG=$TERMUX_STANDALONE_TOOLCHAIN/bin/pkg-config
		
	python3 $TERMUX_PKG_SRCDIR/configure.py \
		--host=x86_64-pc-linux-gnu \
		--target=$TERMUX_HOST_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		 \
		--enable-audio-backends=aaudio,opensl \
		--enable-minify=properties,js \
		--with-wasm-sandboxed-libraries=
}
