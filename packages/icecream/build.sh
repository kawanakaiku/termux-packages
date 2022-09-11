TERMUX_PKG_HOMEPAGE=https://github.com/icecc/icecream
TERMUX_PKG_DESCRIPTION="Distributed compiler with a central scheduler to share build load"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_SRCURL=https://github.com/icecc/icecream/releases/download/${TERMUX_PKG_VERSION}/icecc-${TERMUX_PKG_VERSION}.0.tar.xz
TERMUX_PKG_SHA256=7d750e8b866215f8b8e93404a75a8d5a9b1c1a675565af847e4d24964ec7d66b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libcap-ng, zstd, libarchive, liblzo"

termux_step_pre_configure() {
	./autogen.sh
}
