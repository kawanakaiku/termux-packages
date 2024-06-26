TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-wavelan-plugin/start
TERMUX_PKG_DESCRIPTION="wavelan status plugin for the Xfce4 panel"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
_MAJOR_VERSION=0.6
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-wavelan-plugin/${_MAJOR_VERSION}/xfce4-wavelan-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=61c0c2f56cb70872d403b770dd76349df9ff24c0dbe905ee1b4f913c34d8f72b
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel"
TERMUX_PKG_BUILD_IN_SRC=true
