TERMUX_PKG_HOMEPAGE=https://coder.com/
TERMUX_PKG_DESCRIPTION="VS Code in the browser"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kawanakaiku"
TERMUX_PKG_VERSION=4.7.0
TERMUX_PKG_SRCURL=https://github.com/coder/code-server.git
TERMUX_PKG_DEPENDS="nodejs, libsecret, ripgrep"

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure() {
	termux_setup_nodejs
}

termux_step_make_install() {
	npm install --force --no-save \
		--prefix ${TERMUX_COMMON_CACHEDIR} \
		node-pre-gyp node-gyp node-gyp-build prebuild-install
		
	export NODE_PATH=${TERMUX_COMMON_CACHEDIR}/node_modules
	export \
		npm_config_build_from_source=true \
		npm_config_platform=android \
		npm_config_arch=$(
			case $TERMUX_ARCH in
				arm) echo arm;;
				aarch64) echo arm64;;
				i686) echo ia32;;
				x86_64) echo x64;;
			esac
		)
	
	npm install --force --no-save \
		--prefix ${TERMUX_PREFIX}/share/code-server \
		--unsafe-perm \
		--legacy-peer-deps --omit=dev \
		${TERMUX_PKG_NAME}@${TERMUX_PKG_VERSION}

	npm cache clean --force

	# install folder
	mv ${TERMUX_PREFIX}/share/code-server{,.bak}
	mv ${TERMUX_PREFIX}/share/code-server.bak/node_modules/code-server ${TERMUX_PREFIX}/share
	rm -r ${TERMUX_PREFIX}/share/code-server.bak

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
	
	# no need
	rm -rf ${TERMUX_PREFIX}/share/code-server/lib/vscode/node_modules/@parcel/watcher/prebuilds
}

termux_step_post_make_install() {
	rm -rf ${TERMUX_PREFIX}/bin/node-pre-gyp
	rm -rf ${TERMUX_PREFIX}/lib/node_modules
	
	(
		# no hard links
		IFS=$'\n'
		abs_to_rel() {
			python - <<-PYTHON
				file_from = "$1".split("/")[1:]
				file_to = "$2".split("/")[1:]
				i = 0
				while i < min(len(file_from), len(file_to)) and file_from[i] == file_to[i]:
				 i += 1
				print( "../" * ( len(file_from) - 1 - i ) + "/".join(file_to[i:]) )
			PYTHON
		}
		cd /
		for HARDLINK in $(find $TERMUX_PREFIX -type f -links +1 | grep -v '^$')
		do
			for FILE in $(find $TERMUX_PREFIX -samefile "$HARDLINK" | grep -v '^$')
			do
				if [ "$HARDLINK" != "$FILE" ]
				then
					rm "$FILE"
					# instead symlink
					echo "running abs_to_rel $FILE $HARDLINK"
					REL="$( abs_to_rel "$FILE" "$HARDLINK")"
					echo "REL=$REL"
					echo "symlinking $REL $FILE"
					ln -s "$REL" "$FILE"
				fi
			done
		done
	)
}

termux_step_install_license() {
	install -Dm600 $TERMUX_PREFIX/share/code-server/LICENSE \
		$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE
}
