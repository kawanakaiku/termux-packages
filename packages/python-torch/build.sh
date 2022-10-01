TERMUX_PKG_HOMEPAGE=https://pytorch.org/
TERMUX_PKG_DESCRIPTION="Tensors and Dynamic neural networks in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.1
TERMUX_PKG_SRCURL=https://github.com/pytorch/pytorch.git
TERMUX_PKG_DEPENDS="python, python-numpy, libprotobuf, libopenblas"
TERMUX_PKG_BUILD_IN_SRC=true
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
	
	build-pip install -U pyyaml numpy

	find . -name CMakeLists.txt -o -name '*.cmake' | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'
	
	sed -i "s|np.get_include()|'${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/include'|" tools/setup_helpers/numpy_.py	
	sed -i 's/**build_options,/**build_options | {i: j for i, j in [i.strip().split("=", 1) for i in os.getenv("termux_cmake_args").split(os.linesep) if "=" in i]},/' tools/setup_helpers/cmake.py
}

_termux_step_configure() {
	:
}

_termux_step_make() {
	:
}

termux_step_make_install() {
	export OpenBLAS_HOME=${TERMUX_PREFIX}
	export MAX_JOBS=${TERMUX_MAKE_PROCESSES}
        export termux_cmake_args="
	CMAKE_C_COMPILER=${CC}
	CMAKE_CXX_COMPILER=${CXX}
	CMAKE_AR=$(command -v $AR)
	CMAKE_UNAME=$(command -v uname)
	CMAKE_RANLIB=$(command -v $RANLIB)
	CMAKE_STRIP=$(command -v $STRIP)
	CMAKE_C_FLAGS=$CFLAGS $CPPFLAGS
	CMAKE_CXX_FLAGS=$CXXFLAGS $CPPFLAGS
	CMAKE_FIND_ROOT_PATH=${TERMUX_PREFIX}
	CMAKE_SKIP_INSTALL_RPATH=ON
	CMAKE_USE_SYSTEM_LIBRARIES=True
	CMAKE_LINKER=$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD $LDFLAGS
        ANDROID=0
	USE_VULKAN=0
	USE_CUDA=0
	USE_CUDNN=0
	USE_MKLDNN=0
	USE_DISTRIBUTED=0
	USE_NINJA=0
	USE_NUMPY=1
	USE_BLAS=1
	BLAS=OpenBLAS
	OpenBLAS_INCLUDE_DIR=${TERMUX_PREFIX}/include/openblas
	USE_ZMQ=0
	USE_FFMPEG=0
	USE_LMDB=0
	USE_LEVELDB=0
	USE_GFLAGS=0
	USE_FFTW=0
	USE_OPENMP=0
	USE_TBB=0
	USE_FAKELOWP=0
	USE_NUMA=0
	USE_NCCL=0
	USE_METAL=0
	USE_SYSTEM_TBB=0
	USE_ROCKSDB=0
	USE_SYSTEM_SLEEF=0
	BUILD_TEST=0
	BUILD_PYTHON=1
	BUILD_CUSTOM_PROTOBUF=0
	CAFFE2_LINK_LOCAL_PROTOBUF=1
	ANDROID_NO_TERMUX=OFF
	NATIVE_BUILD_DIR=${TERMUX_PKG_HOSTBUILD_DIR}
	PROTOBUF_PROTOC_EXECUTABLE=$(command -v protoc)
	CAFFE2_CUSTOM_PROTOC_EXECUTABLE=$(command -v protoc)
	OPENMP_FLAG=-fopenmp -static-openmp
	BUILD_CAFFE2=1
	UNIX=1
	USE_FBGEMM=0
        "
	LDFLAGS+=" -llog"
	CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	LDFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	
	cross-pip -v install $TERMUX_PKG_SRCDIR || for log in build/CMakeFiles/*.log; do echo "log file: $log"; cat $log; done
}
