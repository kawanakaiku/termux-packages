TERMUX_PKG_HOMEPAGE=https://coder.com/
TERMUX_PKG_DESCRIPTION="VS Code in the browser"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kawanakaiku"
TERMUX_PKG_VERSION=4.6.0
TERMUX_PKG_SRCURL=https://github.com/coder/code-server.git
 TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_nodejs
	npm install -g yarn
find ~ -name yarn
}

termux_step_make_install() {
	yarn install --cwd ${TERMUX_PREFIX} .
}
