TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Libpeas
TERMUX_PKG_DESCRIPTION="Application plugin library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="kawanakaiku"
TERMUX_PKG_VERSION=1.32.0
#TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libpeas/${TERMUX_PKG_VERSION%.*}/libpeas-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/main/libp/libpeas/libpeas_${TERMUX_PKG_VERSION}.orig.tar.xz
TERMUX_PKG_SHA256=d625520fa02e8977029b246ae439bc218968965f1e82d612208b713f1dcc3d0e
TERMUX_PKG_DEPENDS="gobject-introspection, glib, gtk3"

_termux_step_pre_configure() {
	# OSError: [Errno 8] Exec format error: '/data/data/com.termux/files/usr/bin/g-ir-scanner'
	cat <<-SH >$TERMUX_PREFIX/bin/g-ir-scanner
	#!$TERMUX_PREFIX/bin/sh
	exit 0
	SH
}

termux_step_pre_configure() {
	# Couldn't find include 'GObject-2.0.gir'
	wget -nv https://github.com/kawanakaiku/test-ci/releases/download/src/gir-1.0.zip
	mkdir -p /usr/share/gir-1.0
	unzip -q gir-1.0.zip -p /usr/share/gir-1.0
}

_termux_step_post_make_install() {
    rm $TERMUX_PREFIX/bin/g-ir-scanner
}

termux_step_post_make_install() {
    rm -r /usr
}
