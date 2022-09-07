TERMUX_PKG_HOMEPAGE=https://coder.com/
TERMUX_PKG_DESCRIPTION="VS Code in the browser"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kawanakaiku"
TERMUX_PKG_VERSION=4.6.1
TERMUX_PKG_SRCURL=https://github.com/coder/code-server.git
TERMUX_PKG_DEPENDS="nodejs"
#TERMUX_PKG_BUILD_DEPENDS="yarn"

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
}

_termux_step_pre_configure() {
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
	
	# node-pre-gyp not found
	yarn global add node-pre-gyp
	
	local bin=/tmp/bin
	mkdir -p $bin
	ln -sf $(which $AR) $bin/$AR
	ln -sf $(which $LD) $bin/$LD
	ln -sf $(which $CC) $bin/$CC
	ln -sf $(which $CXX) $bin/$CXX
	PATH="$bin:$PATH"
}

_termux_step_make_install() {
	export LINK="$CXX"
	yarn --verbose add --modules-folder ${TERMUX_PREFIX}/share/code-server/node_modules \
		code-server@${TERMUX_PKG_VERSION}
		
	ln -s ${TERMUX_PREFIX}/share/code-server/node_modules/.bin/code-server ${TERMUX_PREFIX}/bin/code-server
}

termux_step_make_install() {
        # node-pre-gyp not found
        npm install --global node-pre-gyp
	
	export FORCE_NODE_VERSION=18
	npm install \
		--prefix ${TERMUX_PREFIX}/share/code-server \
		--unsafe-perm \
		code-server@${TERMUX_PKG_VERSION}
		
	local sh=${TERMUX_PREFIX}/bin/code-server
	cat <<-SH > ${sh}
	#!${TERMUX_PREFIX}/bin/sh
	exec ${TERMUX_PREFIX}/share/code-server/node_modules/.bin/code-server --auth none --disable-telemetry "\$@"
	SH
	chmod +x ${sh}
}

termux_step_post_make_install() {
	rm ${TERMUX_PREFIX}/bin/node-pre-gyp
	rm -r ${TERMUX_PREFIX}/lib/node_modules
	
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
				print( "../" * ( len(file_from)  - 1 - i ) + "/".join(file_to[i:]) )
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
	:
}
