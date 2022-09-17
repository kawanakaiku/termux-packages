TERMUX_PKG_HOMEPAGE=https://packages.ubuntu.com/impish/midori
TERMUX_PKG_DESCRIPTION="fast, lightweight graphical web browser"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=7.0
TERMUX_PKG_SRCURL=http://archive.ubuntu.com/ubuntu/pool/universe/m/midori/midori_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=905b2cf721f1dbfbee974c56b328870f462bd68c1dd27dc6890ce852aeb4cd39
TERMUX_PKG_DEPENDS="libsqlite, glib, libsoup, gtk3, webkit2gtk, gcr, libpeas"
TERMUX_PKG_BUILD_DEPENDS="valac, intltool, libexpat"

termux_step_pre_configure() {
	for pkg in ${TERMUX_PKG_DEPENDS//,/} ${TERMUX_PKG_BUILD_DEPENDS//,/}; do
		apt install -y $pkg || true
	done
	
	# Could not find GIR file 'Gtk-3.0.gir'; check XDG_DATA_DIRS or use --includedir
	wget -nv https://github.com/kawanakaiku/test-ci/releases/download/src/gir-1.0.zip
	mkdir -p $TERMUX_PREFIX/share/gir-1.0
	unzip -q gir-1.0.zip -d $TERMUX_PREFIX/share/gir-1.0
	
	# error: Package `gcr-ui-3' not found in specified Vala API directories or GObject-Introspection GIR directories
	wget -nv https://github.com/kawanakaiku/test-ci/releases/download/src/vapi.zip
	mkdir -p $TERMUX_PREFIX/share/vala/vapi
	unzip -n -q vapi.zip -d $TERMUX_PREFIX/share/vala/vapi
}

termux_step_post_make_install() {
	rm -r $TERMUX_PREFIX/share/gir-1.0
	rm -r $TERMUX_PREFIX/share/vala/vapi
}
