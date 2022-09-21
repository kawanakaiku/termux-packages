TERMUX_PKG_HOMEPAGE=https://www.thunderbird.net
TERMUX_PKG_DESCRIPTION="Email, RSS and newsgroup client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=102.3.0+build1
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/main/t/thunderbird/thunderbird_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=bf819fd8770fd725ecc219e2d8bfc775b74c0581a24cefe67c8d04020d11b328
TERMUX_PKG_DEPENDS="pango, libxrandr, libxcomposite, libxcursor, libxdamage, libxfixes, libxi, libxtst, libsm, gtk3, dbus, dbus-glib, libandroid-sysv-semaphore"

termux_step_pre_configure() {
  termux_setup_nodejs
  termux_setup_rust
  
  cargo install cbindgen
  
  touch netwerk/test/unit/data/signed_win.exe
  sed -i -e 's|canonical_os = "Android"|canonical_os = "GNU"|' build/moz.configure/init.configure
  sed -i -e 's|die(|log.error("preventing to die: ",|' toolkit/moz.configure build/moz.configure/rust.configure
  sed -i -e 's|alsa_enabled or midir_linux_support|False|' toolkit/moz.configure
  sed -i -e "s|rustc_target = find_candidate(candidates)|rustc_target = '$CARGO_TARGET_NAME'|" build/moz.configure/rust.configure
  sed -i -e '/RUSTFLAGS/d' build/moz.configure/rust.configure
  sed -i -e 's|if sysroot.path:|if False:|' build/moz.configure/toolchain.configure
  sed -i -e 's|\$target|__no_termux__|' build/autoconf/android.m4
  sed -i -e "s|\$(moztopsrcdir)|$TERMUX_PKG_SRCDIR|" $( grep -rl -e '\$(moztopsrcdir)' )
  sed -i -e 's|defined(DARWIN)|defined(__ANDROID__)|' nsprpub/pr/src/pthreads/ptsynch.c
  sed -i -E 's|,"[a-z0-9/]+\.dll":"[a-z0-9]+"||g' third_party/rust/libloading/.cargo-checksum.json
}

termux_step_configure() {
  touch $TERMUX_BUILD_TS_FILE
  
  python3 $TERMUX_PKG_SRCDIR/configure.py \
    --host=x86_64-pc-linux-gnu \
    --target=$TERMUX_HOST_PLATFORM \
    --prefix=$TERMUX_PREFIX \
    --with-branding=comm/mail/branding/thunderbird \
    --enable-audio-backends=aaudio,opensl \
    --without-wasm-sandboxed-libraries \
    --disable-updater
}
