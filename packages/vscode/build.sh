TERMUX_PKG_HOMEPAGE=https://code.visualstudio.com/
TERMUX_PKG_DESCRIPTION="Visual Studio Code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kawanakaiku"
TERMUX_PKG_VERSION=1.71.0
TERMUX_PKG_SRCURL=https://github.com/microsoft/vscode.git
TERMUX_PKG_DEPENDS="nodejs-lts, libx11, libsecret, libxkbfile"

termux_step_get_source() {
	git clone --recursive --depth=1 --branch=${TERMUX_PKG_VERSION} ${TERMUX_PKG_SRCURL} ${TERMUX_PKG_SRCDIR}
}

termux_step_make_install() {
	npm install -g yarn
	
	touch ${TERMUX_BUILD_TS_FILE}
	
	yarn add --production --verbose --prefix ${TERMUX_PREFIX} ${TERMUX_PKG_SRCDIR}
	yarn cache clean
}

termux_step_install_license() {
	:
}
