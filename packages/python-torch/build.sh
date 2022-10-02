TERMUX_PKG_HOMEPAGE=https://pytorch.org/
TERMUX_PKG_DESCRIPTION="Tensors and Dynamic neural networks in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.1
TERMUX_PKG_SRCURL=https://github.com/pytorch/pytorch.git
TERMUX_PKG_DEPENDS="python, python-numpy, libprotobuf, libopenblas"
#TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	termux_setup_cmake
}

termux_step_host_build() {
	cmake "$TERMUX_PKG_SRCDIR/third_party/sleef"
	make -j "$TERMUX_MAKE_PROCESSES"
}

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
	
	build-pip install -U pyyaml numpy typing_extensions

	find . -name CMakeLists.txt -o -name '*.cmake' | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'
	
	sed -i "s|np.get_include()|'${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/include'|" tools/setup_helpers/numpy_.py	
	sed -i 's/**build_options,/**build_options | {i: j for i, j in [i.strip().split("=", 1) for i in os.getenv("termux_cmake_args").split(os.linesep) if "=" in i]},/' tools/setup_helpers/cmake.py
	
	mkdir build
	
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-DBUILD_PYTHON=True
	-DBUILD_TEST=False
	-DCMAKE_BUILD_TYPE=Release
	-DCMAKE_INSTALL_PREFIX=${TERMUX_PKG_SRCDIR}/torch
	-DCMAKE_PREFIX_PATH=${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages
	-DNUMPY_INCLUDE_DIR=$( echo ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/*/numpy/core/include )
	-DPYTHON_EXECUTABLE=$(command -v python3)
	-DPYTHON_INCLUDE_DIR=${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}
	-DPYTHON_LIBRARY=${TERMUX_PREFIX}/lib//libpython${_PYTHON_VERSION}.so
	-DTORCH_BUILD_VERSION=${TERMUX_PKG_VERSION}
	-DUSE_NUMPY=True
	
	-DANDROID_NO_TERMUX=OFF
	-DOpenBLAS_INCLUDE_DIR=${TERMUX_PREFIX}/include/openblas
	-DNATIVE_BUILD_DIR=${TERMUX_PKG_HOSTBUILD_DIR}
	-DPROTOBUF_PROTOC_EXECUTABLE=$(command -v protoc)
	-DCAFFE2_CUSTOM_PROTOC_EXECUTABLE=$(command -v protoc)
	"
	
	ln -s "$TERMUX_PKG_BUILDDIR" build
}

_termux_step_configure() {
	:
}

_termux_step_make() {
	:
}

termux_step_make_install() {
	cross-pip -v install "$TERMUX_PKG_SRCDIR"
}
