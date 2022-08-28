TERMUX_PKG_HOMEPAGE=https://www.tensorflow.org/
TERMUX_PKG_DESCRIPTION="TensorFlow is an open source machine learning framework for everyone."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=2.9.1
TERMUX_PKG_SRCURL=https://github.com/tensorflow/tensorflow.git
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true

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
	
	LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	
	echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/libpthread.so
	
	build-pip install -U numpy
	
	local BAZEL_VERSION=5.3.0
	BAZEL_FOLDIR=${TERMUX_COMMON_CACHEDIR}/bazel-${BAZEL_VERSION}
	mkdir -p ${BAZEL_FOLDIR}
	wget -nv https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 -O ${BAZEL_FOLDIR}/bazel
	chmod +x ${BAZEL_FOLDIR}/bazel
	export PATH="${BAZEL_FOLDIR}:$PATH"
	
	# ld.lld: error: unable to find library -lpthread
	# force pass flags
	(
		CC=$( which $CC )
		CC_TO=${CC}_$( date '+%Y%m%d%H%M%S' )
		mv ${CC} ${CC_TO}
		cat <<-SH > ${CC}
		#!/usr/bin/sh
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
			exec ${CC_TO} "\$@"
		SH
		chmod +x ${CC}
	)
}

termux_step_configure() {
	./configure
}

termux_step_make() {
	# host build
	echo 'exports_files(["workspace.bzl"])' >> third_party/flatbuffers/BUILD
	env --ignore-environment PATH="$BAZEL_FOLDIR:/usr/bin" bazel build --local_ram_resources=6144 --verbose_failures --subcommands //third_party/flatbuffers:workspace.bzl
	# cross build
	bazel build --local_ram_resources=6144 --verbose_failures --subcommands //tensorflow/tools/pip_package:build_pip_package
}

termux_step_make_install() {
	pip install --prefix=$TERMUX_PREFIX tensorflow-*.whl
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/lib/libpthread.so
}
