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
	
	yarn add --production --verbose --cwd ${TERMUX_PREFIX} ${TERMUX_PKG_SRCDIR}
	yarn cache clean
}

termux_step_post_make_install() {
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
