TERMUX_PKG_HOMEPAGE=http://www.xmlsoft.org
TERMUX_PKG_DESCRIPTION="Library for parsing XML documents"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.10
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libxml2/${_MAJOR_VERSION}/libxml2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5d2cc3d78bec3dbe212a9d7fa629ada25a7da928af432c93060ff5c17ee28a9c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-python
--with-legacy
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc"
TERMUX_PKG_DEPENDS="libiconv, liblzma, zlib"
TERMUX_PKG_BREAKS="libxml2-dev"
TERMUX_PKG_REPLACES="libxml2-dev"
