TERMUX_PKG_HOMEPAGE=https://pytorch.org/
TERMUX_PKG_DESCRIPTION="Tensors and Dynamic neural networks in Python"
TERMUX_PKG_LICENSE="BSD-3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.1
TERMUX_PKG_SRCURL=https://github.com/pytorch/pytorch.git
TERMUX_PKG_DEPENDS="python, python-numpy, libprotobuf, libopenblas"

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	
	termux_setup_protobuf
	
	build-pip install pyyaml
}

termux_step_configure() {
	:
}

termux_step_make() {
	:
}

termux_step_make_install() {
	cross-pip -v install $TERMUX_PKG_SRCDIR
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/lib/librt.so $TERMUX_PREFIX/lib/libpthread.so
}

