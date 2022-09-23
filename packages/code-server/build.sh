TERMUX_PKG_HOMEPAGE=https://coder.com/
TERMUX_PKG_DESCRIPTION="VS Code in the browser"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kawanakaiku"
TERMUX_PKG_VERSION=4.7.0
TERMUX_PKG_SRCURL=https://github.com/coder/code-server.git
TERMUX_PKG_DEPENDS="nodejs, libsecret, ripgrep"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_nodejs
	
	local node_dir=$TERMUX_COMMON_CACHEDIR/node_dir
	npm install --prefix $node_dir yarn typescript
	PATH="$node_dir/node_modules/.bin:$PATH"

	export npm_config_build_from_source=true
	export npm_config_platform=android
	export npm_config_arch=$(
			case $TERMUX_ARCH in
				arm) echo arm;;
				aarch64) echo arm64;;
				i686) echo ia32;;
				x86_64) echo x64;;
			esac
		)
	export PYTHON=/usr/bin/python3
}

termux_step_make() {
	# cannot locate symbol "_ZN2v82V812ToLocalEmptyEv" referenced by "/data/data/com.termux/files/usr/share/code-server/lib/vscode/node_modules/spdlog/build/Release/spdlog.node"
	#export CXXFLAGS+=" -DUSING_V8_SHARED=0"
	
	yarn install --production
	yarn build
	yarn build:vscode
	yarn release
	yarn postinstall
}

termux_step_make_install() {
	mv release $TERMUX_PREFIX/share/code-server

	# @vscode/ripgrep@1.14.2 postinstall
	# Error: Unknown platform: android
	local dir=${TERMUX_PREFIX}/share/code-server/lib/vscode/node_modules/@vscode/ripgrep/bin
	mkdir -p ${dir}
	ln -sf ${TERMUX_PREFIX}/bin/rg ${dir}

	# terminal not working
	# https://github.com/coder/code-server/issues/5496
	sed -i -e 's|switch(process.platform)|switch("linux")|' ${TERMUX_PREFIX}/share/code-server/lib/vscode/out/vs/platform/terminal/node/ptyHostMain.js

	# starter script
	local sh=${TERMUX_PREFIX}/bin/code-server
	cat <<-SH > ${sh}
	#!${TERMUX_PREFIX}/bin/sh
	exec ${TERMUX_PREFIX}/share/code-server/out/node/entry.js --auth none --disable-telemetry --disable-update-check "\$@"
	SH
	chmod +x ${sh}
}
