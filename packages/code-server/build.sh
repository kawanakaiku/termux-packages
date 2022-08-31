TERMUX_PKG_HOMEPAGE=https://coder.com/
TERMUX_PKG_DESCRIPTION="VS Code in the browser"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kawanakaiku"
TERMUX_PKG_VERSION=4.6.0
TERMUX_PKG_SRCURL=https://github.com/coder/code-server.git
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_BUILD_DEPENDS="yarn"

termux_step_get_source() {
	:
}

termux_step_pre_configure() {
	termux_setup_nodejs
	
	local bin=$TERMUX_PKG_BUILDDIR/_bin
	mkdir -p $bin
	
	local yarn=$bin/yarn
	cat > $yarn <<-EOF
		#!$(command -v sh)
		exec sh $TERMUX_PREFIX/bin/yarn "\$@"
		EOF
	chmod 0755 $yarn

	export PATH=$bin:$PATH
}

termux_step_make_install() {
	yarn install --modules-folder ${TERMUX_PREFIX}/share/code-server/node_modules \
		code-server@${TERMUX_PKG_VERSION}
}
