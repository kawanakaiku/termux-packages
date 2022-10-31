TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cce6f0ed6bcf47d54fe5caae14862bfb5a2e39eec1b3b467a8ed1050c298d0ec
TERMUX_PKG_AUTO_UPDATE=true
# ncurses-utils for tput which asciinema uses:
TERMUX_PKG_DEPENDS="python, ncurses-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_HAS_DEBUG=false

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

termux_step_pre_configure() {
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	build-pip install wheel
}

termux_step_make() {
	return
}

termux_step_make_install() {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	pip install --no-deps . --prefix $TERMUX_PREFIX
}
