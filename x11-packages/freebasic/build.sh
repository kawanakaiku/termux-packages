TERMUX_PKG_HOMEPAGE=https://www.freebasic.net/
TERMUX_PKG_DESCRIPTION="A free BASIC compiler"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.09.0
TERMUX_PKG_SRCURL=https://github.com/freebasic/fbc/releases/download/${TERMUX_PKG_VERSION}/FreeBASIC-${TERMUX_PKG_VERSION}-source-bootstrap.tar.xz
TERMUX_PKG_SHA256=26a57c165f1c997ba7ab4c0cd9f984c752c22cd5bca434df2d8cb95c3d5549a4
TERMUX_PKG_BUILD_IN_SRC=true
#TERMUX_PKG_DEPENDS=""
TERMUX_PKG_EXTRA_MAKE_ARGS="
TARGET=$TERMUX_HOST_PLATFORM
"

termux_step_pre_configure() {
(unset sudo; sudo apt update; sudo apt install libtinfo5)
termux_download \
https://sourceforge.net/projects/fbc/files/FreeBASIC-1.09.0/Binaries-Linux/FreeBASIC-1.09.0-linux-x86_64.tar.xz \
${TERMUX_PKG_TMPDIR}/FreeBASIC-linux-x86_64.tar.xz \
c8143b1207541ddcdf8d5d87f36a85a8bf6fdf85b3e6aee56323a0ecdacbc1e5
_HOST_FBC=${TERMUX_PKG_TMPDIR}/host-fbc
mkdir $_HOST_FBC
tar xf ${TERMUX_PKG_TMPDIR}/FreeBASIC-linux-x86_64.tar.xz -C $_HOST_FBC --strip-components 1
PATH="$_HOST_FBC/bin:$PATH"
}
