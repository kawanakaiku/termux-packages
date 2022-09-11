TERMUX_PKG_HOMEPAGE=https://github.com/icecc/icecream
TERMUX_PKG_DESCRIPTION="Distributed compiler with a central scheduler to share build load"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_SRCURL=https://github.com/icecc/icecream.git
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libcap-ng, zstd, libarchive, liblzo"

termux_step_pre_configure() {
	./autogen.sh
}
