TERMUX_PKG_HOMEPAGE=https://pypi.org/
TERMUX_PKG_DESCRIPTION="python3 packages collection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=2022.08.25
# TERMUX_PKG_BUILD_DEPENDS="python, libxml2, libxslt, libgmp, libmpc, libmpfr, freetype, portaudio"
# TERMUX_PKG_BUILD_DEPENDS="python, freetype, libjpeg-turbo, libpng, portmidi, sdl2, sdl2-image, sdl2-mixer, sdl2-ttf, ffmpeg"
# TERMUX_PKG_BUILD_DEPENDS="python, glu, freeglut, mesa"
# TERMUX_PKG_BUILD_DEPENDS="python, mesa, glib, gstreamer, sdl2, sdl2-image, sdl2-mixer, sdl2-ttf"
# TERMUX_PKG_BUILD_DEPENDS="python, libopenblas, libgeos, ffmpeg"
# TERMUX_PKG_BUILD_DEPENDS="python, double-conversion, ffmpeg, fontconfig-utils, freeglut, freetype, glib, glu, graphviz, gstreamer, leptonica, libgeos, libgmp, libhdf5, libjpeg-turbo, libmpc, libmpfr, libopenblas, libpng, libprotobuf, libsndfile, libsodium, libuv, libxml2, libxslt, libyaml, libzmq, lz4, mesa, pcre, portaudio, portmidi, qpdf, sdl2, sdl2-image, sdl2-mixer, sdl2-ttf, tesseract, zbar, zlib, freetype, libimagequant, libjpeg-turbo, littlecms, openjpeg, libraqm, libtiff, libwebp, libxcb, zlib, libjpeg-turbo, libpng, libprotobuf, libtiff, libwebp, openjpeg, openjpeg-tools, zlib"
TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_NO_STATICSPLIT=true

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
_PYTHON_FULL_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $TERMUX_PKG_VERSION)

termux_step_pre_configure() {

	local PYTHON_PKGS PYTHON_PKGS_OK PYTHON_PKG

	PYTHON_PKGS=( )
	PYTHON_PKGS+=( yt-dlp streamlink gallery-dl )
	PYTHON_PKGS+=( pytz python-dateutil tqdm )
	PYTHON_PKGS+=( gmpy2 )
	PYTHON_PKGS+=( beautifulsoup4 certifi demjson3 mechanize colorama cloudscraper )
	PYTHON_PKGS+=( cffi )
	PYTHON_PKGS+=( h5py )
	PYTHON_PKGS+=( jupyter )
	#PYTHON_PKGS+=( biopython )
	PYTHON_PKGS+=( matplotlib )
	PYTHON_PKGS+=( pytest )
	PYTHON_PKGS+=( sympy )
	#PYTHON_PKGS+=( pyqt5 )
	PYTHON_PKGS+=( pyaudio )
	PYTHON_PKGS+=( soundfile )
	PYTHON_PKGS+=( moviepy pygame )
	PYTHON_PKGS+=( pyyaml )
	PYTHON_PKGS+=( pydantic )
	PYTHON_PKGS+=( pyworld )
	PYTHON_PKGS+=( pyopengl )
	PYTHON_PKGS+=( django )  # backports.zoneinfo error: use of undeclared identifier '_PyLong_One'
	PYTHON_PKGS+=( flask )
	PYTHON_PKGS+=( pyftpdlib pysmb )
	PYTHON_PKGS+=( kivy )
	PYTHON_PKGS+=( pycodestyle pyflakes flake8 pylint autopep8 yapf black autoflake isort )
	PYTHON_PKGS+=( py7zr )
	PYTHON_PKGS+=( zstd )
	#PYTHON_PKGS+=( zbar )  # ./zbarmodule.h:42:5: error: unknown type name 'PyIntObject'; did you mean 'PySetObject'?
	#PYTHON_PKGS+=( pikepdf )  # cannot locate symbol "__aarch64_ldadd8_acq_rel"
	#PYTHON_PKGS+=( numba )  # llvmlite: RuntimeError: Building llvmlite requires LLVM 11.x.x, got '14.0.6git'
	PYTHON_PKGS+=( bx )
	PYTHON_PKGS+=( pyscss )
	PYTHON_PKGS+=( onnx )
	#PYTHON_PKGS+=( tensorflow )  # need bazel
	PYTHON_PKGS+=( pygraphviz )
	PYTHON_PKGS+=( lz4 )
	#PYTHON_PKGS+=( mappy )  # arm: emmintrin.h:14:2: error: "This header is only meant to be used on x86 and x64 architecture"
	PYTHON_PKGS+=( yarl )
	PYTHON_PKGS+=( wrapt )
	PYTHON_PKGS+=( vispy )
	PYTHON_PKGS+=( ujson )
	PYTHON_PKGS+=( uvloop )
	#PYTHON_PKGS+=( ginga )  # requires astropy
	#PYTHON_PKGS+=( mecab )  # requires mecab
	PYTHON_PKGS+=( chardet )
	PYTHON_PKGS+=( openpyxl )
	PYTHON_PKGS+=( python-pptx )
	PYTHON_PKGS+=( python-docx )
	#PYTHON_PKGS+=( notofonttools )  # skia-pathops: error: could not parse cython version from pyproject.toml
	PYTHON_PKGS+=( tesserocr )
	PYTHON_PKGS+=( pynacl zfec )
	PYTHON_PKGS+=( bcrypt homeassistant orjson sqlalchemy )
	#PYTHON_PKGS+=( numpy opencv-contrib-python scipy tqdm colorama scikit-learn scikit-image shapely yt-dlp pip beautifulsoup4 certifi demjson3 mechanize colorama cloudscraper lxml pandas cryptography pillow pyzmq pygame pynacl matplotlib jupyter uvloop )
	PYTHON_PKGS+=( yt-dlp )
	PYTHON_PKGS+=( matplotlib )
	PYTHON_PKGS+=( pip wheel setuptools )
	PYTHON_PKGS+=( h5py streamlink gallery-dl )
	#PYTHON_PKGS+=( cmake )  # The C++ compiler does not support C++11 (e.g.  std::unique_ptr).
	PYTHON_PKGS+=( ipython notebook )
	PYTHON_PKGS=( onnx )
	
	
	PYTHON_PKGS_OK=( )
	

	# for accurate dependency
	
	download_extract_deb_file() {(
		echo "runnning download_extract_deb_file $@" >&2
		PKG=$1
		cd "$TERMUX_SCRIPTDIR"
		#read PKG_DIR <<< $(./scripts/buildorder.py 2>/dev/null | awk -v PKG="$PKG" '{if($1==PKG){print $2; exit;}}')
		PKG_DIR=$(
			for i in packages root-packages x11-packages
			do
				if [ -d $i/$PKG ]
				then
					echo $i/$PKG
					exit
				else
					f=$( echo $i/*/${PKG}.subpackage.sh | head -n1 )
					if [ -f $f ]
					then
						dirname $f
						exit
					fi
				fi
			done
			echo ERROR
		)
		read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info "$PKG" "${PKG_DIR}")
		termux_download_deb_pac $PKG $DEP_ARCH $DEP_VERSION $DEP_VERSION_PAC
		cd $TERMUX_COMMON_CACHEDIR-$DEP_ARCH
		rm -f data.tar.xz; mkfifo data.tar.xz
		tar Jxf data.tar.xz --strip-components=1 --no-overwrite-dir -C / &
		ar x ${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
		rm -f data.tar.xz
	)}

	get_pkg_files() {(
		local PKG
		for PKG do
			local TMP_FILE=${TERMUX_COMMON_CACHEDIR}/get_pkg_files_${PKG}
			if [ ! -f ${TMP_FILE} ]; then
				local TMP_DIR=${TERMUX_PKG_TMPDIR}/get_deb_files_${RANDOM}
				local DEB_FILE=${TERMUX_COMMON_CACHEDIR}-*/${PKG}_*_*.deb
				if [ ! -f ${DEB_FILE} ]; then
					download_extract_deb_file ${PKG} >&2
				fi
				mkdir ${TMP_DIR}
				cd ${TMP_DIR}

				mkfifo data.tar.xz
				tar Jtf data.tar.xz > ${TMP_FILE} &
				ar x $DEB_FILE data.tar.xz

				cd ${OLDPWD}
				rm -rf ${TMP_DIR}
			fi
			cat ${TMP_FILE}
		done
	)}
	
	get_pkgs_depends() {(
		local TMP_BUILDER_DIR=$TERMUX_SCRIPTDIR/packages/nonexist
		mkdir $TMP_BUILDER_DIR
		cat <<-SH > $TMP_BUILDER_DIR/build.sh
		TERMUX_PKG_DEPENDS="$( echo -n "$1"; shift; for arg; do echo -n ", $arg"; done )"
		SH
		
		cd "$TERMUX_SCRIPTDIR"
		./scripts/buildorder.py -i "$TMP_BUILDER_DIR" packages root-packages x11-packages | awk '{print $1}' | grep -v -e ndk-sysroot -e $TERMUX_PKG_NAME
		cd "$OLDPWD"
		
		rm -rf $TMP_BUILDER_DIR
	)}
	
	disable_all_files() {(
		(
			# cache files list
			# disable all installed files
			get_pkg_files $( get_pkgs_depends $TERMUX_PKG_NAME )
			cat ${TERMUX_COMMON_CACHEDIR}/get_pkg_files_*
		) |
		while read f; do if test -f "$f"; then mv "$f" "$f.disabling"; fi; done
	)}
	
	enable_python_pkg_files() {
		# install just required packages
		disable_all_files
		local PYTHON_PKG=$1
		local PYTHON_PKG_REQUIRES=( python $( manage_depends $PYTHON_PKG ) )
		local PYTHON_PKG_REQUIRES_RECURSIVE=( $( get_pkgs_depends "${PYTHON_PKG_REQUIRES[@]}" ) )
		echo "$( get_pkg_files $( get_pkgs_depends ${PYTHON_PKG_REQUIRES_RECURSIVE[@]} ) )" | while read f; do if test -f "$f.disabling"; then mv "$f.disabling" "$f"; fi; done
	}
	
	
	# for building onnx
	# termux_setup_cmake
	# termux_setup_ninja
	
	# clang-14: error: the clang compiler does not support '-march=native'
	# by numpy distutils  ex) scikit-learn
	# force remove it
	(
		CC=$( which $CC )
		CC_TO=${CC}_$( date '+%Y%m%d%H%M%S' )
		mv ${CC} ${CC_TO}
		cat <<-SH > ${CC}
		#!/usr/bin/sh
		for arg do
			shift
			[ "\$arg" = "-march=native" ] && continue
			set -- "\$@" "\$arg"
		done
		exec ${CC_TO} "\$@"
		SH
		chmod +x ${CC}
	)

	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	
	LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	
	echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/librt.so
	echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/libpthread.so
	
	export PIP_DISABLE_PIP_VERSION_CHECK=on
	export PATH="$PATH:${_CROSSENV_PREFIX}/build/bin"  # for maturin, cython command
	
	# cannot locate "__aarch64_ldadd4_acq_rel"
	# only in arm: error: /home/builder/.termux-build/_cache/fortran/bin/../lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a(linux-atomic.o): multiple definition of '__sync_fetch_and_add_4'
	if [ $TERMUX_ARCH != arm ]; then
		export LDFLAGS+=" $($CC -print-libgcc-file-name)"
	fi

	cross-pip install -U pip wheel
	build-pip install -U pip setuptools wheel Cython toml
	
	_termux_setup_rust() {
		termux_setup_rust
		export CARGO_BUILD_TARGET="$CARGO_TARGET_NAME"  # for setuptools_rust
		export PYO3_CROSS_LIB_DIR=$TERMUX_PREFIX/lib  # The PYO3_CROSS_LIB_DIR environment variable must be set when cross-compiling
		
		# error: attempted to link to Python shared library but config does not contain lib_name ex) bcrypt
		cat <<-EOF > $HOME/.cargo/pyo3-termux.conf
		version=${_PYTHON_VERSION}
		lib_name=python${_PYTHON_VERSION}
		lib_dir=$TERMUX_PREFIX/lib
		EOF
		export PYO3_CONFIG_FILE=$HOME/.cargo/pyo3-termux.conf
		#export PYO3_PRINT_CONFIG=1
		
		_termux_setup_rust() {
			echo termux_setup_rust already setup
		}
	}
	
	_termux_setup_fortran() {
		local TERMUX_FORTRAN_FOLDER=$TERMUX_COMMON_CACHEDIR/fortran
		local ARCH
		case $TERMUX_ARCH in
			aarch64 ) ARCH=arm64 ;;
			i686 ) ARCH=x86 ;;
			* ) ARCH=$TERMUX_ARCH ;;
		esac
		local TAR_BZ2=gcc-$ARCH-linux-x86_64.tar.bz2
		mkdir -p $TERMUX_FORTRAN_FOLDER
		(
			cd $TERMUX_PKG_TMPDIR
			wget -nv -O $TAR_BZ2 https://github.com/mzakharo/android-gfortran/releases/download/r21e/$TAR_BZ2
			tar -xf $TAR_BZ2 -C $TERMUX_FORTRAN_FOLDER --strip-components=1

			cd $TERMUX_FORTRAN_FOLDER/lib/gcc/$TERMUX_HOST_PLATFORM/*
			for i in $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/*; do
				ln -sf $i
			done
		)
		
		export PATH="$PATH:$TERMUX_FORTRAN_FOLDER/bin"
		export FC=$TERMUX_HOST_PLATFORM-gfortran
		
		# aarch64-linux-android-gfortran: error: unrecognized command line option '-static-openmp'
		# make link gfortran for numpy
		(
			FC=$( which $FC )
			FC_TO=${FC}_$( date '+%Y%m%d%H%M%S' )
			mv ${FC} ${FC_TO}
			cat <<-SH > ${FC}
			#!/usr/bin/sh
			for arg do
				shift
				[ "\$arg" = "-static-openmp" ] && continue
				set -- "\$@" "\$arg"
			done
			exec ${FC_TO} "\$@"
			SH
			chmod +x ${FC}
			
			ln -sf ${FC} $( dirname $FC_TO )/gfortran
		)
		
		cat <<-FORTRAN > hello.f90
		program hello
		 print *, 'Hello World!'
		end program hello
		FORTRAN
		$FC -o hello hello.f90
		rm hello.f90 hello

		_termux_setup_fortran() {
			echo termux_setup_fortran already setup
		}
	}
	
	_termux_setup_protobuf() {
		termux_setup_protobuf
		
		_termux_setup_protobuf() {
			echo termux_setup_protobuf already setup
		}
	}
	
	_termux_setup_cmake() {
		termux_setup_cmake
		
		_termux_setup_cmake() {
			echo termux_setup_cmake already setup
		}
	}
	_termux_setup_cmake
	
	_termux_setup_ninja() {
		termux_setup_ninja
		
		_termux_setup_ninja() {
			echo termux_setup_ninja already setup
		}
	}
	_termux_setup_ninja
	
	(
		# get_cmake_args
		cmake() {
			local arg
			for arg do
				if [[ "${arg}" = -D* ]]; then
					echo "${arg}"
				fi
			done
		}
		termux_step_configure_cmake > ${TERMUX_COMMON_CACHEDIR}/tmp_cmake_args || true
		echo "termux_step_configure_cmake args:"
		cat ${TERMUX_COMMON_CACHEDIR}/tmp_cmake_args
	)
	
	
	manage_depends() {
		local PYTHON_PKG=$1
		
		case $PYTHON_PKG in
			lxml ) printf 'libxml2 libxslt' ;;
			gmpy2 ) printf 'libgmp libmpc libmpfr' ;;
			numpy ) printf 'libopenblas' ;;
			scipy ) printf 'libopenblas' ;;
			pynacl ) printf 'libsodium' ;;
			pyzmq ) printf 'libzmq' ;;
			yt-dlp ) printf 'ffmpeg' ;;
			h5py ) printf 'libhdf5' ;;
			matplotlib ) printf 'freetype' ;;
			pyaudio ) printf 'portaudio' ;;
			pygame ) printf 'freetype libjpeg-turbo libpng portmidi sdl2 sdl2-image sdl2-mixer sdl2-ttf' ;;
			moviepy ) printf 'ffmpeg' ;;
			soundfile ) printf 'libsndfile' ;;
			pyyaml ) printf 'libyaml' ;;
			pyopengl ) printf 'glu freeglut mesa' ;;
			kivy ) printf 'mesa glib gstreamer sdl2 sdl2-image sdl2-mixer sdl2-ttf' ;;
			zbar ) printf 'zbar' ;;
			pikepdf ) printf 'qpdf' ;;
			bx ) printf 'zlib' ;;
			pyscss ) printf 'pcre' ;;
			onnx ) printf 'libprotobuf' ;;
			pygraphviz ) printf 'graphviz' ;;
			lz4 ) printf 'lz4' ;;
			mappy ) printf 'zlib' ;;
			vispy ) printf 'mesa fontconfig-utils' ;;
			uvloop ) printf 'libuv' ;;
			ujson ) printf 'double-conversion' ;;
			tesserocr ) printf 'tesseract leptonica' ;;
			homeassistant ) printf 'python-sqlalchemy' ;;
			shapely ) printf 'libgeos' ;;
			pillow ) printf 'freetype libimagequant libjpeg-turbo littlecms openjpeg libraqm libtiff libwebp libxcb zlib' ;;
			opencv-contrib-python ) printf 'libjpeg-turbo libpng libprotobuf libtiff libwebp openjpeg openjpeg-tools zlib' ;;
		esac
	}
	
	manage_exports() {
		case $PYTHON_PKG in
			numpy ) export MATHLIB=m ;;
			pynacl ) export build_alias=$CCTERMUX_HOST_PLATFORM host_alias=x86_64-pc-linux-gnu ;;
			h5py ) export HDF5_DIR=$TERMUX_PREFIX HDF5_VERSION=1.12.0 H5PY_ROS3=-1 H5PY_DIRECT_VFD=-1 ;;
			_matplotlib ) export NPY_DISABLE_SVML=1 ;;
			pygame ) export LOCALBASE=$(dirname $TERMUX_PREFIX) ;;
			uvloop ) export LIBUV_CONFIGURE_HOST=x86_64-pc-linux-gnu ;;
			scipy ) export SCIPY_USE_PYTHRAN=1 ;;
			pyzmq ) export ZMQ_PREFIX=${TERMUX_PREFIX} ;;
			opencv-contrib-python )
				export LDFLAGS+=" -llog"
				# -DWITH_FFMPEG=OFF for error: use of undeclared identifier 'CODEC_ID_H264'; did you mean 'AV_CODEC_ID_H264'?
				# -DOPENCV_EXTRA_MODULES_PATH=<opencv_contrib>/modules for with extra
				;;
			onnx )
				# Could NOT find PythonLibs (missing: PYTHON_LIBRARIES) (found version "3.10.6")
				# Could NOT find pybind11 (missing: pybind11_DIR)
				#export CMAKE_ARGS="-DPYTHON_INCLUDE_DIRS=${TERMUX_PREFIX}/include -DPYTHON_LIBRARIES=${TERMUX_PREFIX}/lib -Dpybind11_DIR=${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/pybind11 -Dpybind11_INCLUDE_DIRS=${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/pybind11/include"
				;;
		esac
	}
	
	patch_src() {
		if [ -f pyproject.toml ]; then
			python <<-PYTHON
			import toml
			t = toml.load(open("pyproject.toml"))
			if "build-system" in t:
			 if "requires" in t["build-system"] and t["build-system"]["requires"] != []:
			  import subprocess
			  for i in t["build-system"]["requires"]:
			   subprocess.run("build-pip install --only-binary :all: -U".split() + [i])
			   subprocess.run("cross-pip install --only-binary :all: -U".split() + [i])
			  t["build-system"]["requires"] = []
			 #if "build-backend" in t["build-system"] and t["build-system"]["build-backend"] != []:
			 # t["build-system"]["build-backend"] = []
			 open("pyproject.toml", "w").write(toml.dumps(t))
			PYTHON
		fi
		if [ -f setup.cfg ]; then
			sed -i -E 's|^install_requires|_disabled_install_requires|' setup.cfg
		fi
		if [ -f setup.py ]; then
			sed -i -z -E 's|setup_requires=|setup_requires=[] and |' setup.py
			sed -i -z -E 's|install_requires=|install_requires=[] and |' setup.py
		fi
		if [ -f *.egg-info/requires.txt ]; then
			# ex) pandas
			rm *.egg-info/requires.txt
		fi
			
		if [ -d ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/mesonbuild/compilers ]; then
			# disable sanitycheck.exe
			perl -i -pe "s|\Qraise mesonlib.EnvironmentException(f'Could not invoke sanity test executable: {e!s}.')\E|return|g" \
				${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/mesonbuild/compilers/mixins/clike.py
			# ERROR: Executables created by Fortran compiler aarch64-linux-android-gfortran are not runnable. ex) scipy
			perl -i -pe "s|\Qraise EnvironmentException\E|print|g" \
				${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/mesonbuild/compilers/fortran.py
		fi
		
		if [ -f ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/Cython/Compiler/Main.py ]; then
			# force cython refer to cross python
			#sed -i -e "s|import sys|import sys; sys.argv = sys.argv[0:1] + ['--include-dir', '${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages'] + sys.argv[1:]|" ${_CROSSENV_PREFIX}/build/bin/cython
			#perl -i -pe "s|\Qself.include_path = []\E|self.include_path = ['${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages']|" ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/Cython/Compiler/Main.py
			# force
			perl -i -pe "s|\Qself.__dict__.update(options)\E|self.__dict__.update(options); self.include_path = ['${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages'] + self.include_path|" ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/Cython/Compiler/Main.py
		fi
		
		case $PYTHON_PKG in
			setuptools )
				rm pyproject.toml
				;;
			matplotlib )
				echo '[libs]' > mplsetup.cfg
				echo 'system_freetype = true' >> mplsetup.cfg
				# error: Failed to download
				termux_download http://www.qhull.org/download/qhull-2020-src-8.0.2.tgz qhull-2020-src-8.0.2.tgz b5c2d7eb833278881b952c8a52d20179eab87766b00b865000469a45c1838b7e
				mkdir -p build
				tar xf qhull-2020-src-8.0.2.tgz -C build
				;;
			pyaudio )
				sed -i -e "s|'/usr/local/include', '/usr/include'|'$TERMUX_PREFIX/include'|" setup.py
				sed -i -e "s|'/usr/local/lib', '/usr/lib'|'$TERMUX_PREFIX/lib'|" setup.py
				;;
			pygame )
				#sed -i -e "s|/usr|$TERMUX_PREFIX|" buildconfig/config_unix.py
				perl -i -pe "s|\Qconfig[0].strip()\E|'$(. $TERMUX_SCRIPTDIR/x11-packages/sdl2/build.sh; echo $TERMUX_PKG_VERSION)'|" buildconfig/config_unix.py
				perl -i -pe "s|\Q' '.join(config[1:]).split()\E|'-I$TERMUX_PREFIX/include/SDL2 -I$TERMUX_PREFIX/include -I$TERMUX_PREFIX/include/freetype2 -DNO_SHARED_MEMORY -D_REENTRANT -D_THREAD_SAFE -L$TERMUX_PREFIX/lib -lSDL2'.split()|" buildconfig/config_unix.py
				;;
			kivy-garden )
				# ModuleNotFoundError: No module named 'ez_setup'
				wget -nv https://raw.githubusercontent.com/kivy-garden/garden/master/ez_setup.py
				;;
			pyppmd )
				# dlopen failed: cannot locate symbol "pthread_cancel"
				sed -i -E 's|pthread_cancel\(([^)]*)\)|pthread_kill(\1, 0)|' src/lib/buffer/ThreadDecoder.c
				;;
			numba )
				# use numpy library
				sed -i -E "s|np_misc.get_info\('npymath'\)|{'include_dirs': ['${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/include'], 'library_dirs': ['${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/lib'], 'libraries': ['m']}|" setup.py
				;;
			llvmlite )
				# RuntimeError: Building llvmlite requires LLVM 11.x.x, got '14.0.6git'. Be sure to set LLVM_CONFIG to the right executable path.
				( unset sudo; sudo apt-get update; sudo apt-get install -y llvm-11 )
				;;
			pynacl )
				# Command '['make', 'check']' returned non-zero exit
				perl -i -pe 's|\Qsubprocess.check_call(["make", "check"]\E|#|' setup.py
				;;
			bcrypt )
				# error: can't find Rust compiler
				_termux_setup_rust
				;;
			orjson )
				# Cargo, the Rust package manager, is not installed or is not on PATH.
				_termux_setup_rust
				;;
			cryptography )
				_termux_setup_rust
				;;
			numpy )
				# _termux_setup_fortran
				# libraries openblas not found in ['/home/builder/.termux-build/python-pkgs/src/python-crossenv-prefix/cross/lib', '/usr/local/lib', '/usr/lib64', '/usr/lib', '/usr/lib/x86_64-linux-gnu']
				perl -i -pe "s|/usr|$TERMUX_PREFIX|g" numpy/distutils/system_info.py
				;;
			scipy )
				_termux_setup_fortran
				(
					for f in $( find -name setup.py -type f )
					do
						perl -i -pe "s|\Qf2py_options = None\E|f2py_options = ['--fcompiler', '$FC']|" $f
					done
				)
				# ld: error: /home/builder/.termux-build/python-pkgs/src/python-crossenv-prefix/build/lib/python3.10/site-packages/numpy/core/include/../lib/libnpymath.a(npy_math.o) is incompatible with aarch64linux
				build-pip install -U numpy pybind11 pythran
				cross_build numpy pybind11 pythran
				#rm -rf ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/numpy/core
				#ln -s ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/numpy/core ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/numpy/core
				perl -i -pe "s|\Qimport os; os.chdir(\"..\"); import numpy; print(numpy.get_include())\E|print(\"${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/include\")|" scipy/meson.build
				perl -i -pe "s|\Qimport pybind11; print(pybind11.get_include())\E|print(\"${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/pybind11/include\")|" scipy/meson.build
				perl -i -pe "s|\Qimport os; os.chdir(\"..\"); import pythran; print(os.path.dirname(pythran.__file__));\E|print(\"${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/pythran\")|" scipy/meson.build
				# scipy/stats/_biasedurn.pyx:13:4: 'numpy/random.pxd' not found
				#perl -i -pe "s|\Q'--include-dir', os.getcwd()]\E|'--include-dir', '${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages', '--include-dir', os.getcwd()]|" scipy/_build_utils/cythoner.py
				# No such file or directory: 'patchelf'
				perl -i -pe "s|\Qlibdir_path not in elf.rpath\E|False|" ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/mesonpy/__init__.py
				;;
			scikit-learn )
				# Error compiling Cython file
				# sklearn/tree/_criterion.pyx:24:0: 'scipy/special/cython_special.pxd' not found
				# needs scipy
				cross_build scipy
				;;
			pillow )
				# /usr/include/pthread.h:710:3: error: 'regparm' is not valid on this platform
				sed -i -e 's|not self.disable_platform_guessing|False|' setup.py
				# fix library_dirs
				sed -i -e "s|sys.prefix|'$TERMUX_PREFIX'|" setup.py
				sed -i -e 's|for dirname in _find_library_dirs_ldconfig():|for dirname in []:|' setup.py
				;;
			pyzmq )
				# Failed to run ['build/temp.linux-aarch64-cpython-310/scratch/vers']: OSError(8, 'Exec format error')
				# sed -i -e "s|self.compiler.has_function('timer_create')|False|" buildutils/detect.py
				# echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/librt.so
				sed -i -e 's|detected = self.test_build(zmq_prefix, self.compiler_settings)|detected = {"vers": (4, 3, 4)}|' setup.py
				;;
			opencv-contrib-python )
				cross_build numpy
				_termux_setup_cmake
				_termux_setup_ninja
				_termux_setup_protobuf
				# OpenCVConfig.cmake.in.patch
				perl -i -pe "s|\Q@OpenCV_INCLUDE_DIRS_CONFIGCMAKE@\E|@TERMUX_PREFIX@/include|" opencv/cmake/templates/OpenCVConfig.cmake.in
				# build.sh tweak
				find . -name CMakeLists.txt -o -name '*.cmake' | \
					xargs -n 1 sed -i \
					-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
					-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'
					
				# with extra modules
				# get_pip_src opencv-contrib-python  # this package includes opencv-python (cv2)
				
				# cmake_args
				# error: CMake-installed files must be within the project root.
				# exclude -DCMAKE_INSTALL_*
				grep -v -e "^-DCMAKE_INSTALL_" ${TERMUX_COMMON_CACHEDIR}/tmp_cmake_args > ${TERMUX_COMMON_CACHEDIR}/tmp_cmake_args_opencv
				# WITH_LAPACK=OFF error: no matching function for call to 'dgeev_'
				cat <<- ARGS >> ${TERMUX_COMMON_CACHEDIR}/tmp_cmake_args_opencv
					-DANDROID_NO_TERMUX=OFF
					-DWITH_OPENEXR=OFF
					-DBUILD_PROTOBUF=OFF
					-DPROTOBUF_UPDATE_FILES=ON
					-DOPENCV_GENERATE_PKGCONFIG=ON
					-DPYTHON_DEFAULT_EXECUTABLE=python
					-DPYTHON3_INCLUDE_PATH=${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}
					-DPYTHON3_NUMPY_INCLUDE_DIRS=${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/include
					-DWITH_FFMPEG=OFF
					-DOPENCV_EXTRA_MODULES_PATH=${PWD}/opencv_contrib/modules
					-DWITH_LAPACK=OFF
				ARGS
				# patch to prevent default
				sed -i -e "s|cmake_args=cmake_args|cmake_args=open('${TERMUX_COMMON_CACHEDIR}/tmp_cmake_args_opencv').read().split(os.linesep)[:-1]|" setup.py
				# No such file or directory: '_skbuild/linux-aarch64-3.10/cmake-install/python/cv2/config-3.py'
				#sed -z -i -e "s|with open('%spython.*custom_init_data)||" setup.py
				sed -i -z -e "s|RearrangeCMakeOutput(\n|RearrangeCMakeOutput = lambda *args: args; RearrangeCMakeOutput(\n|" setup.py
				;;
			onnx )
				# Protobuf compiler not found
				_termux_setup_protobuf
				perl -i -pe "s|\\$\{_PROTOBUF_INSTALL_PREFIX\}|${TERMUX_PREFIX}|" CMakeLists.txt
				
				# Could NOT find pybind11 (missing: pybind11_DIR)
				#build-pip install -U pybind11
				#cross_build pybind11
				
				# Python config failure: Python is 64-bit, chosen compiler is 32-bit
				perl -i -pe 's|message\(FATAL_ERROR|message(STATUS|' third_party/pybind11/tools/FindPythonLibsNew.cmake
				;;
		esac
	}
	
	manage-opts() {
		case $PYTHON_PKG in
			uvloop )
				# cannot locate symbol "uv__pthread_sigmask"
				echo build_ext --use-system-libuv
				;;
			pillow )
				echo build_ext --enable-zlib --enable-jpeg --enable-tiff --enable-freetype --enable-raqm --enable-lcms --enable-webp --enable-webpmux --enable-jpeg2000 --enable-imagequant --enable-xcb
				;;
		esac
	}
	
	to_pkgname() {
		# PySocks -> python-pysocks
		# python-dateutil -> python-dateutil
		local pkg
		for pkg; do
			pkg=${pkg,,}
			[[ $pkg == python-* ]] || pkg=python-${pkg}
			echo $pkg
		done
	}
	
	get_pip_src() {
		local json url sha256 filename json dir
		local PYTHON_PKG=$1
		
		case $PYTHON_PKG in
			tensorflow )
				git clone https://github.com/tensorflow/tensorflow.git --depth=1 --branch=v${TERMUX_SUBPKG_VERSION}
				return ;;
		esac
		
		json="$( get_pypi_json $PYTHON_PKG | jq -r '[.releases[.info.version][] | select(.packagetype=="sdist")][0]' )"
		url=$( echo "$json" | jq -r '.url' )
		sha256=$( echo "$json" | jq -r '.digests.sha256' )
		filename="$( echo "$json" | jq -r '.filename' )"  # filename with space ex) kivy-garden
		termux_download $url "$filename" $sha256
		case $filename in
			*.tar.* ) tar xf "$filename"; dir="${filename%%.tar.*}" ;;
			*.zip ) unzip -q "$filename"; dir="${filename%%.zip}" ;;
			* ) echo "unknown archive $filename"; exit 1 ;;
		esac
		rm $filename
		mv "$dir" $PYTHON_PKG
	}
	
	get_requires() {(
		local PYTHON_PKG=$1
		
		REQUIRES=$(
		case $PYTHON_PKG in
			matplotlib ) printf 'cycler kiwisolver' ;;
		esac
		)
		echo "$REQUIRES "
		
		python <<-PYTHON
		import re, json
		j = json.loads(r'''$( get_pypi_json $PYTHON_PKG )''')

		implementation_name = "cpython"
		implementation_version = "$_PYTHON_FULL_VERSION"
		os_name = "posix"
		platform_machine = "$TERMUX_ARCH"
		platform_system = "Linux"
		python_full_version = "$_PYTHON_FULL_VERSION"
		platform_python_implementation = "CPython"
		python_version = "$_PYTHON_VERSION"
		sys_platform = "linux"
		extra = ""

		requires = []
		
		# already included
		no_need = "dataclasses typing".split()

		for require in j["info"]["requires_dist"] or []:
		 ok = True
		 if ";" in require:
		  require, condition = [i.strip() for i in require.split(";", 1)]
		  # condition = re.sub("extra\s*==", "True or ", condition)  # ignore extra
		  exec(f"if not ({condition}): ok=False")
		 require = re.split("=|<|>|\(|!", require)[0].strip()
		 require = require.split("[", 1)[0]
		 if ok and ( require.lower() not in no_need ):
		  requires += [require]

		print(" ".join(sorted(set(requires))))
		PYTHON
	)}
	
	get_pypi_json() {
		local PYTHON_PKG=$1
		local file=${TERMUX_COMMON_CACHEDIR}/tmp_pypi_json_${PYTHON_PKG}
		if [ ! -f $file ]; then
			curl --silent https://pypi.org/pypi/$PYTHON_PKG/json > ${TERMUX_COMMON_CACHEDIR}/tmp_pypi_json_${PYTHON_PKG}
		fi
		cat $file
	}
	
	cross_build() {
		local PYTHON_PKG PYTHON_PKG_REQUIRES
		local TERMUX_SUBPKG_DESCRIPTION TERMUX_SUBPKG_DEPENDS TERMUX_SUBPKG_INCLUDE TERMUX_SUBPKG_PLATFORM_INDEPENDENT TERMUX_SUBPKG_VERSION 
		local TERMUX_FILES_LIST_BEFORE TERMUX_FILES_LIST_AFTER

		for PYTHON_PKG in $@; do

			[[ " ${PYTHON_PKGS_OK[*]} " =~ " $PYTHON_PKG " ]] && continue
			
			# order: setuptools => wheel => pip (last)
			#[[ " setuptools wheel pip " =~ " $PYTHON_PKG " ]] && continue

			echo "Processing $PYTHON_PKG ..."
			
			enable_python_pkg_files $PYTHON_PKG

			PYTHON_PKG_REQUIRES=( $( get_requires $PYTHON_PKG ) )
			echo "PYTHON_PKG_REQUIRES='${PYTHON_PKG_REQUIRES[@]}'"
			PYTHON_PKGS+=( "${PYTHON_PKG_REQUIRES[@]}" )
			TERMUX_SUBPKG_DESCRIPTION="$( get_pypi_json $PYTHON_PKG | jq -r '.info.summary' | sed -e 's|"|\\"|g' )"
			if [ "$TERMUX_SUBPKG_DESCRIPTION" == "" ]; then
				# this may be empty  ex) traitlets==5.3.0
				TERMUX_SUBPKG_DESCRIPTION="Python package $PYTHON_PKG"
			fi
			TERMUX_SUBPKG_VERSION="$( get_pypi_json $PYTHON_PKG | jq -r '.info.version' )"
			TERMUX_SUBPKG_DEPENDS=( python $( to_pkgname "${PYTHON_PKG_REQUIRES[@]}" ) $( manage_depends $PYTHON_PKG ) )
			TERMUX_SUBPKG_DEPENDS=( $( printf '%s\n' "${TERMUX_SUBPKG_DEPENDS[*]}" | sort | uniq ) )
			TERMUX_SUBPKG_DEPENDS="$( echo "${TERMUX_SUBPKG_DEPENDS[*]}" | sed -e 's| |, |g' )"

			get_pip_src $PYTHON_PKG

			pushd $PYTHON_PKG
			patch_src
			popd
			
			TERMUX_FILES_LIST_BEFORE="$( cd $TERMUX_PREFIX && find . -type f,l | sort )"
			(
				cd $PYTHON_PKG
				manage_exports
				cross-pip -v install --upgrade --force-reinstall --no-deps --no-binary :all: --prefix $TERMUX_PREFIX --no-build-isolation --no-cache-dir --compile $(for opt in $( manage-opts ); do echo "--install-option=$opt"; done ) .
				#python setup.py install --prefix $TERMUX_PREFIX  # creates egg
			)
			TERMUX_FILES_LIST_AFTER="$( cd $TERMUX_PREFIX && find . -type f,l | sort )"
			
			TERMUX_SUBPKG_INCLUDE="$( comm -13 <( echo "$TERMUX_FILES_LIST_BEFORE" ) <( echo "$TERMUX_FILES_LIST_AFTER" ) )"
			
			if [ "$PYTHON_PKG" = "pip" ]; then
				# /home/builder/.termux-build/python-pkgs/src/python-crossenv-prefix/cross/bin/pip: not found
				cross-python -m pip install --upgrade --force-reinstall pip
			fi

			if [ "$TERMUX_SUBPKG_INCLUDE" == "" ]; then
				echo "no file added while installing $PYTHON_PKG"
				continue
			else
				TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
				echo "setting TERMUX_SUBPKG_PLATFORM_INDEPENDENT for $PYTHON_PKG"
				TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$(
					cd $TERMUX_PREFIX
					while read f; do
						if [[ $f = *.so ]] || [[ $f = *.a ]]; then
							echo "file '$f' found" 1>&2
							echo false
							exit
						elif [[ $f = */bin/* ]] && ! grep -qI . $f; then
							echo "file '$f' is binary" 1>&2
							echo false
							exit
						fi
					done <<< "$TERMUX_SUBPKG_INCLUDE"
					echo "seems to be TERMUX_SUBPKG_PLATFORM_INDEPENDENT" 1>&2
					echo true
				)

				TERMUX_SUBPKG_INCLUDE="$(
					awk_cmd=''
					cd ${TERMUX_PREFIX}
					INFO_DIR=$( echo "$TERMUX_SUBPKG_INCLUDE" | grep -oP '.+\.(dist-info|egg-info)' | head -n1 )
					
					# awk_cmd_dist="gsub( /\/site-packages\//, \"/dist-packages/\", \$1 ); "
					awk_cmd_so="if ( \$1 ~ /.*\.so$/ ) { gsub( /cpython-${_PYTHON_VERSION//.}-.*\.so$/, \"cpython-${_PYTHON_VERSION//.}.so\", \$1 ); print; next }; "
					awk_cmd_man="if ( \$1 ~ /.*\/share\/man\/.*/ ) { if ( \$1 ~ /.*\/share\/man\/man.*/ ) { if ( \$1 ~ /.*\/share\/man\/man.*/ ) {} else { \$1 = \$1 \".gz\" }; print }; next }"
					awk_cmd_url="if ( \$1 ~ /\/direct_url\.json$/ ) { next }; "
					awk_cmd+="${awk_cmd_so}; ${awk_cmd_man}; ${awk_cmd_url}"
					
					while read f; do
						if [[ "$f" = ./lib/python${_PYTHON_VERSION}/site-packages/* ]]; then
							if [[ "$f" = $INFO_DIR/direct_url.json ]]; then
								# avoid pip freeze from showing build dir
								rm "$f"
								continue
							fi
							# orjson.cpython-310-aarch64-linux-gnu.so -> orjson.cpython-310.so
							_f="$( echo $f | gawk "{ ${awk_cmd_so}; print }" )"
							if [ "$f" != "$_f" ]; then
								echo "mv '$f' '$_f'" 1>&2
								mv "$f" "$_f"
							fi
							echo "$_f"
						elif [[ "$f" = ./share/man/* ]]; then
							if [[ "$f" = ./share/man/man* ]]; then
								# termux_step_massage: pages will be gzipped
								if [[ "$f" = *.gz ]]; then
									echo "${f}"
								else
									echo "${f}.gz"
								fi
							else
								# termux_step_massage: folders will be removed
								rm "$f"
							fi
						else
							# no process needed
							echo "$f"
						fi
					done <<< "$TERMUX_SUBPKG_INCLUDE"
					
					for f in $INFO_DIR/RECORD $INFO_DIR/installed-files.txt
					do
						if [ -f "$f" ]; then
							gawk -F, -v OFS=, -i inplace "{ ${awk_cmd}; print }" $f
						fi
					done
				)"
				
				# move to dist-packages after all build
				#mkdir -p ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/dist-packages/
				#mv ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/* ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/dist-packages/
				TERMUX_SUBPKG_INCLUDE="$( echo "$TERMUX_SUBPKG_INCLUDE" | sed -e 's|/site-packages/|/dist-packages/|' )"
				
				echo "TERMUX_SUBPKG_INCLUDE=${TERMUX_SUBPKG_INCLUDE}"

				cat <<- EOF > ${TERMUX_PKG_TMPDIR}/$( to_pkgname ${PYTHON_PKG} ).subpackage.sh
				TERMUX_SUBPKG_DESCRIPTION="$TERMUX_SUBPKG_DESCRIPTION"
				TERMUX_SUBPKG_DEPENDS="$TERMUX_SUBPKG_DEPENDS"
				TERMUX_SUBPKG_INCLUDE="$TERMUX_SUBPKG_INCLUDE"
				TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$TERMUX_SUBPKG_PLATFORM_INDEPENDENT
				TERMUX_SUBPKG_DEPEND_ON_PARENT=no
				TERMUX_SUBPKG_VERSION=$TERMUX_SUBPKG_VERSION
				
				termux_step_create_subpkg_debscripts() {
					cat <<SH > postinst
					#!${TERMUX_PREFIX}/bin/bash
					f=${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/dist-packages.pth
					if [ -f \\\$f ]
					then
						echo '../dist-packages' >\\\$f
					fi
					SH
					
					cat <<SH > postrm
					#!${TERMUX_PREFIX}/bin/bash
					if [ -z "\\\$(ls -A ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/dist-packages 2>/dev/null)" ]
					then
						rm -f ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/dist-packages.pth
					fi
					SH
				}
				EOF
			fi

			PYTHON_PKGS_OK+=( $PYTHON_PKG )
		
		done
	}
	
	for PYTHON_PKG in ${PYTHON_PKGS[@]}; do build-pip install --upgrade $PYTHON_PKG || true; done
	
	while [ ${#PYTHON_PKGS[@]} -ne 0 ]
	do
		PYTHON_PKG=${PYTHON_PKGS[0],,}
		PYTHON_PKGS=( "${PYTHON_PKGS[@]:1}" )
		
		cross_build $PYTHON_PKG
	done
	
	# rm all installed files
	disable_all_files
	#echo "$( get_pkg_files $( get_pkgs_depends $TERMUX_PKG_NAME ) )" | while read f; do rm -f "$f.disabling"; done
	find $TERMUX_PREFIX -name "*.disabling" -type f,l -delete
	
	# move to dist
	rm -rf ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/dist-packages
	mv ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages ${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/dist-packages
}

termux_step_configure() { :; }

termux_step_make() { :; }

termux_step_make_install() { :; }

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/lib/librt.so $TERMUX_PREFIX/lib/libpthread.so
}

termux_step_install_license() { :; }
