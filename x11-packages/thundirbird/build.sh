TERMUX_PKG_HOMEPAGE=https://www.thunderbird.net
TERMUX_PKG_DESCRIPTION="Email, RSS and newsgroup client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=102.3.0+build1
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/main/t/thunderbird/thunderbird_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=bf819fd8770fd725ecc219e2d8bfc775b74c0581a24cefe67c8d04020d11b328

termux_step_configure() {
  python3 $TERMUX_PKG_SRCDIR/configure.py \
    --host=x86_64-pc-linux-gnu \
    --target=$TERMUX_HOST_PLATFORM \
    --prefix=$TERMUX_PREFIX \
    --disable-compile-environment \
    --disable-updater
}
