TERMUX_PKG_HOMEPAGE=https://code.visualstudio.com/
TERMUX_PKG_DESCRIPTION="Visual Studio Code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kawanakaiku"
TERMUX_PKG_VERSION=1.71.0
TERMUX_PKG_SRCURL=https://github.com/microsoft/vscode/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fb106039f73ddefdf81b393d29af6f35e262628c39007307b6748dc2ee786ea6
TERMUX_PKG_DEPENDS="nodejs-lts, libx11, libsecret, libxkbfile"
TERMUX_PKG_BUILD_DEPENDS="yarn"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	yarn add --prefix ${TERMUX_PREFIX} ${TERMUX_PKG_SRCDIR}

	yarn cache clean
}
