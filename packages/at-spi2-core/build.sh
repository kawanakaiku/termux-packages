TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Accessibility
TERMUX_PKG_DESCRIPTION="Assistive Technology Service Provider Interface (AT-SPI)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.46
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/at-spi2-core/${_MAJOR_VERSION}/at-spi2-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=aa0c86c79f7a8d67bae49a5b7a5ab08430c608cffe6e33bf47a72f41ab03c3d0
TERMUX_PKG_DEPENDS="dbus, glib, libx11, libxi, libxtst"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, libxml2"
TERMUX_PKG_PROVIDES="at-spi2-atk, atk"
TERMUX_PKG_REPLACES="at-spi2-atk (<< 2.46.0), atk (<< 2.46.0), libatk"
TERMUX_PKG_BREAKS="at-spi2-atk (<< 2.46.0), atk (<< 2.46.0), libatk"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddbus_daemon=$TERMUX_PREFIX/bin/dbus-daemon
-Dintrospection=yes
-Dx11=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
