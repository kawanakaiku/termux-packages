TERMUX_PKG_HOMEPAGE=https://pypi.org/
TERMUX_PKG_DESCRIPTION="python3 packages collection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@kawanakaiku"
TERMUX_PKG_VERSION=2022.08.25
# TERMUX_PKG_BUILD_DEPENDS="python, libxml2, libxslt, libgmp, libmpc, libmpfr, freetype, portaudio"
# TERMUX_PKG_BUILD_DEPENDS="python, freetype, libjpeg-turbo, libpng, portmidi, sdl2, sdl2-image, sdl2-mixer, sdl2-ttf, ffmpeg"
# TERMUX_PKG_BUILD_DEPENDS="python, glu, freeglut, mesa"
# TERMUX_PKG_BUILD_DEPENDS="python, mesa, glib, gstreamer, sdl2, sdl2-image, sdl2-mixer, sdl2-ttf"
TERMUX_PKG_BUILD_DEPENDS="python, libopenblas"
#TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
_PYTHON_FULL_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $TERMUX_PKG_VERSION)

termux_step_pre_configure() {
	# for building onnx
	# termux_setup_cmake
	# termux_setup_ninja

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
	export PATH="$PATH:${_CROSSENV_PREFIX}/build/bin"  # for maturin command

	cross-pip install -U pip wheel
	build-pip install -U pip setuptools wheel Cython toml
	
	local PYTHON_PKGS PYTHON_PKGS_OK PYTHON_PKG PYTHON_PKG_REQUIRES PYTHON_JSON
	local TERMUX_SUBPKG_DESCRIPTION TERMUX_SUBPKG_DEPENDS TERMUX_SUBPKG_INCLUDE TERMUX_SUBPKG_PLATFORM_INDEPENDENT TERMUX_SUBPKG_VERSION
	local manage_depends to_pkgname get_pip_src get_requires
	local _termux_setup_rust _termux_setup_fortran
	local opt
	
	_termux_setup_rust() {
		termux_setup_rust
		export CARGO_BUILD_TARGET="$CARGO_TARGET_NAME"  # for setuptools_rust
		export PYO3_CROSS_LIB_DIR=$TERMUX_PREFIX/lib  # The PYO3_CROSS_LIB_DIR environment variable must be set when cross-compiling
		
		# error: attempted to link to Python shared library but config does not contain lib_name ex) bcrypt
		cat <<-EOF > $HOME/.cargo/pyo3-termux.conf
		version=3.10
		lib_name=python3.10
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
	
	PYTHON_PKGS=( )
	PYTHON_PKGS+=( yt-dlp streamlink gallery-dl )
	PYTHON_PKGS+=( pytz python-dateutil tqdm )
	PYTHON_PKGS+=( gmpy2 )
	PYTHON_PKGS=( beautifulsoup4 certifi demjson3 mechanize colorama cloudscraper )
	PYTHON_PKGS=( cffi )
	PYTHON_PKGS=( h5py )
	PYTHON_PKGS=( jupyter )
	#PYTHON_PKGS=( biopython )
	PYTHON_PKGS=( matplotlib )
	PYTHON_PKGS=( pytest )
	PYTHON_PKGS=( sympy )
	#PYTHON_PKGS=( pyqt5 )
	PYTHON_PKGS=( pyaudio )
	PYTHON_PKGS=( soundfile )
	PYTHON_PKGS=( moviepy pygame )
	PYTHON_PKGS=( pyyaml )
	PYTHON_PKGS=( pydantic )
	PYTHON_PKGS=( pyworld )
	PYTHON_PKGS=( pyopengl )
	PYTHON_PKGS=( django )  # backports.zoneinfo error: use of undeclared identifier '_PyLong_One'
	PYTHON_PKGS=( flask )
	PYTHON_PKGS=( pyftpdlib pysmb )
	PYTHON_PKGS=( kivy )
	PYTHON_PKGS=( pycodestyle pyflakes flake8 pylint autopep8 yapf black autoflake isort )
	PYTHON_PKGS=( py7zr )
	PYTHON_PKGS=( zstd )
	#PYTHON_PKGS=( zbar )  # ./zbarmodule.h:42:5: error: unknown type name 'PyIntObject'; did you mean 'PySetObject'?
	#PYTHON_PKGS=( pikepdf )  # cannot locate symbol "__aarch64_ldadd8_acq_rel"
	#PYTHON_PKGS=( numba )  # llvmlite: RuntimeError: Building llvmlite requires LLVM 11.x.x, got '14.0.6git'
	PYTHON_PKGS=( bx )
	PYTHON_PKGS=( pyscss )
	PYTHON_PKGS=( onnx )
	#PYTHON_PKGS=( tensorflow )  # need bazel
	PYTHON_PKGS=( pygraphviz )
	PYTHON_PKGS=( lz4 )
	#PYTHON_PKGS=( mappy )  # arm: emmintrin.h:14:2: error: "This header is only meant to be used on x86 and x64 architecture"
	PYTHON_PKGS=( yarl )
	PYTHON_PKGS=( wrapt )
	PYTHON_PKGS=( vispy )
	PYTHON_PKGS=( ujson )
	PYTHON_PKGS=( uvloop )
	#PYTHON_PKGS=( ginga )  # requires astropy
	#PYTHON_PKGS=( mecab )  # requires mecab
	PYTHON_PKGS=( chardet )
	PYTHON_PKGS=( openpyxl )
	PYTHON_PKGS=( python-pptx )
	PYTHON_PKGS=( python-docx )
	#PYTHON_PKGS=( notofonttools )  # skia-pathops: error: could not parse cython version from pyproject.toml
	PYTHON_PKGS=( tesserocr )
	PYTHON_PKGS=( pynacl zfec )
	PYTHON_PKGS=( bcrypt homeassistant orjson sqlalchemy )
	PYTHON_PKGS=( scipy )
	PYTHON_PKGS=( numpy )
	
	PYTHON_PKGS_OK=( )
	manage_depends() {
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
		esac
	}
	manage_exports() {
		case $PYTHON_PKG in
			numpy ) printf "MATHLIB=m" ;;
			pynacl ) printf "build_alias=$CCTERMUX_HOST_PLATFORM host_alias=x86_64-pc-linux-gnu" ;;
			h5py ) printf "HDF5_DIR=$TERMUX_PREFIX HDF5_VERSION=1.12.0 H5PY_ROS3=-1 H5PY_DIRECT_VFD=-1" ;;
			matplotlib ) printf "NPY_DISABLE_SVML=1" ;;
			pygame ) printf "LOCALBASE=$(dirname $TERMUX_PREFIX)" ;;
			uvloop ) printf "LIBUV_CONFIGURE_HOST=x86_64-pc-linux-gnu" ;;
		esac
	}
	patch_src() {
		if [ -d ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/mesonbuild/compilers ]; then
			# disable sanitycheck.exe
			perl -i -pe "s|\Qraise mesonlib.EnvironmentException(f'Could not invoke sanity test executable: {e!s}.')\E|return|g" \
				${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/mesonbuild/compilers/mixins/clike.py
			# ERROR: Executables created by Fortran compiler aarch64-linux-android-gfortran are not runnable. ex) scipy
			perl -i -pe "s|\Qraise EnvironmentException\E|print|g" \
				${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/mesonbuild/compilers/fortran.py
		fi
		
		case $PYTHON_PKG in
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
			scipy )
				_termux_setup_fortran
				(
				for f in $( find -name setup.py -type f )
				do
					perl -i -pe "s|\Qf2py_options = None\E|f2py_options = ['--fcompiler', '$FC']|" $f
				done
				)
				# aarch64-linux-android-gfortran: error: unrecognized command line option '-static-openmp'
				LDFLAGS="${LDFLAGS/-static-openmp/}"
				;;
		esac
	}
	manage-opts() {
		case $PYTHON_PKG in
			uvloop )
				# cannot locate symbol "uv__pthread_sigmask"
				echo build_ext --use-system-libuv
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
		case $PYTHON_PKG in
			tensorflow )
				git clone https://github.com/tensorflow/tensorflow.git --depth=1 --branch=v${TERMUX_SUBPKG_VERSION}
				return ;;
		esac
		json="$( echo "$PYTHON_JSON" | jq -r '[.releases[.info.version][] | select(.packagetype=="sdist")][0]' )"
		url=$( echo "$json" | jq -r '.url' )
		sha256=$( echo "$json" | jq -r '.digests.sha256' )
		filename="$( echo "$json" | jq -r '.filename' )"  # filename with space ex) kivy-garden
		termux_download $url "$filename" $sha256
		case $filename in
			*.tar.* ) tar xf "$filename"; dir="${filename%%.tar.*}" ;;
			*.zip ) unzip -q "$filename"; dir="${filename%%.zip}" ;;
			* ) echo "unknown archive $filename"; exit 1 ;;
		esac
		mv "$dir" $PYTHON_PKG
	}
	get_requires() {
		python <<-PYTHON
		import re, json
		j = json.load(open("/tmp/tmp_python_json"))

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
		 require = re.split("=|<|>|\(", require)[0].strip()
		 require = require.split("[", 1)[0]
		 if ok and ( require.lower() not in no_need ):
		  requires += [require]

		print(" ".join(sorted(set(requires))))
		PYTHON
	}
	
	(
		exit 0
		local url file
		url=https://github.com/kawanakaiku/src/releases/download/termux-python
		file=python-numpy_1.23.2_$TERMUX_ARCH.deb
		curl --location --output $file $url/$file
		ar x $file data.tar.xz
		if tar -tf data.tar.xz|grep "^./$">/dev/null; then
			tar -xf data.tar.xz --strip-components=1 --no-overwrite-dir -C /
		else
			tar -xf data.tar.xz --no-overwrite-dir -C /
		fi
		rm $file data.tar.xz
	)
	
	for PYTHON_PKG in ${PYTHON_PKGS[@]}; do build-pip install --upgrade $PYTHON_PKG || true; done
	
	# disable requirements
	#sed -i -e 's|_get_build_requires(self, config_settings, requirements):|_get_build_requires(self, config_settings, requirements):\n        return []|' ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/setuptools/build_meta.py
	
	# avoid Installing build dependencies: finished with status 'error'
	#sed -i -z -E 's|self\.req\.build_env\.install_requirements\([^\)]*\)||' ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/pip/_internal/distributions/sdist.py
	#sed -i -z -E 's|call_subprocess\([^\)]*\)|pass|' ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/pip/_internal/build_env.py
	
	# avoid Getting requirements to build wheel: finished with status 'error'
	#sed -i -z -E 's|runner = runner_with_spinner_message\(([^\)]*)\)|print(\1); return []|g' ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/pip/_internal/build_env.py
	#sed -i -e 's|Getting requirements to build wheel|test build Getting requirements to build wheel|' ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/pip/_internal/build_env.py
	#sed -i -e 's|Getting requirements to build wheel|test cross Getting requirements to build wheel|' ${_CROSSENV_PREFIX}/cross/lib/python${_PYTHON_VERSION}/site-packages/pip/_internal/build_env.py
	#sed -i -e 's|super().get_requires_for_build_wheel(config_settings=cs)|[]|' ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/pip/_internal/utils/misc.py
	
	# avoid 
	#sed -i -e 's|backend.prepare_metadata_for_build_wheel(metadata_dir)|"prepare_metadata_for_build_wheel_metadata_dir.dist-info"|' ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages/pip/_internal/operations/build/metadata.py
	
	while [ ${#PYTHON_PKGS[@]} -ne 0 ]
	do
		PYTHON_PKG=${PYTHON_PKGS[0],,}
		PYTHON_PKGS=( "${PYTHON_PKGS[@]:1}" )
		[[ " ${PYTHON_PKGS_OK[*]} " =~ " $PYTHON_PKG " ]] && continue
		[[ " pip " =~ " $PYTHON_PKG " ]] && [ ${#PYTHON_PKGS[@]} -ne 0 ] && PYTHON_PKGS+=( $PYTHON_PKG ) && continue
		[[ " setuptools wheel " =~ " $PYTHON_PKG " ]] && ( for pkg in ${PYTHON_PKGS[*]}; do [[ " pip setuptools wheel "  =~ " $pkg " ]] || exit 0; done; exit 1 ) && PYTHON_PKGS+=( $PYTHON_PKG ) && continue
		[[ " pandas cryptography pillow pyzmq lxml freetype  cv2 matplotlib " =~ " $PYTHON_PKG " ]] && continue
		
		echo "Processing $PYTHON_PKG ..."
		
		PYTHON_JSON="$( curl --silent https://pypi.org/pypi/$PYTHON_PKG/json )"
		echo "$PYTHON_JSON" > /tmp/tmp_python_json
		
		PYTHON_PKG_REQUIRES=( $( get_requires ) )
		echo "PYTHON_PKG_REQUIRES='${PYTHON_PKG_REQUIRES[@]}'"
		PYTHON_PKGS+=( "${PYTHON_PKG_REQUIRES[@]}" )
		TERMUX_SUBPKG_DESCRIPTION="$( echo "$PYTHON_JSON" | jq -r '.info.summary' | sed -e 's|"|\\"|g' )"
		if [ "$TERMUX_SUBPKG_DESCRIPTION" == "" ]; then
			# this may be empty  ex) traitlets==5.3.0
			TERMUX_SUBPKG_DESCRIPTION="Python package $PYTHON_PKG"
		fi
		TERMUX_SUBPKG_VERSION="$( echo "$PYTHON_JSON" | jq -r '.info.version' )"
		TERMUX_SUBPKG_DEPENDS=( python $( to_pkgname "${PYTHON_PKG_REQUIRES[@]}" ) $( manage_depends ) )
		TERMUX_SUBPKG_DEPENDS=( $( printf '%s\n' "${TERMUX_SUBPKG_DEPENDS[*]}" | sort | uniq ) )
		TERMUX_SUBPKG_DEPENDS="$( echo "${TERMUX_SUBPKG_DEPENDS[*]}" | sed -e 's| |, |g' )"
		
		get_pip_src $PYTHON_PKG
		
		( cd $TERMUX_PREFIX && find . -type f,l | sort ) > TERMUX_FILES_LIST_BEFORE
		
		(
		cd $PYTHON_PKG
		if [ -f pyproject.toml ]; then
			python <<-PYTHON
			import toml
			t = toml.load(open("pyproject.toml"))
			if "build-system" in t:
			 if "requires" in t["build-system"] and t["build-system"]["requires"] != []:
			  import subprocess
			  subprocess.run("build-pip install -U".split() + t["build-system"]["requires"])
			  subprocess.run("cross-pip install -U".split() + t["build-system"]["requires"])
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
		patch_src
		export $( manage_exports ) > /dev/null
		cross-pip -vv install --upgrade --force-reinstall --no-deps --no-binary :all: --prefix $TERMUX_PREFIX --no-build-isolation --no-cache-dir $(for opt in $( manage-opts ); do echo "--install-option=$opt"; done ) .
		#python setup.py install --prefix $TERMUX_PREFIX  # creates egg
		)
		( cd $TERMUX_PREFIX && find . -type f,l | sort ) > TERMUX_FILES_LIST_AFTER
		TERMUX_SUBPKG_INCLUDE="$( comm -13 TERMUX_FILES_LIST_BEFORE TERMUX_FILES_LIST_AFTER )"
		rm TERMUX_FILES_LIST_BEFORE TERMUX_FILES_LIST_AFTER
		
		if [ "$TERMUX_SUBPKG_INCLUDE" == "" ]; then
			echo "no file added while installing $PYTHON_PKG"
			continue
		else
			TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
			if ( echo "$TERMUX_SUBPKG_INCLUDE" | grep -q '.so$' ); then
				TERMUX_SUBPKG_PLATFORM_INDEPENDENT=false
			elif [ -n "$( echo "$TERMUX_SUBPKG_INCLUDE" | grep -q "^$TERMUX_PREFIX/bin/" | xargs -I@ sh -c 'grep -qI . @ || echo @' )" ]; then
				TERMUX_SUBPKG_PLATFORM_INDEPENDENT=false
			fi
			
			TERMUX_SUBPKG_INCLUDE="$(
			# orjson.cpython-310-aarch64-linux-gnu.so -> orjson.cpython-310.so
			cd $TERMUX_PREFIX
			for f in $TERMUX_SUBPKG_INCLUDE
			do
				_f=$( echo $f | sed -E "s|cpython-${_PYTHON_VERSION//.}-.*\.so$|cpython-${_PYTHON_VERSION//.}.so|" )
				if [ $f != $_f ]; then
					echo "moving '$f' to '$_f'" 1>&2
					mv $f $_f
				fi
				echo $_f
			done
			)"

			cat <<- EOF > ${TERMUX_PKG_TMPDIR}/$( to_pkgname ${PYTHON_PKG} ).subpackage.sh
			TERMUX_SUBPKG_DESCRIPTION="$TERMUX_SUBPKG_DESCRIPTION"
			TERMUX_SUBPKG_DEPENDS="$TERMUX_SUBPKG_DEPENDS"
			TERMUX_SUBPKG_INCLUDE="$TERMUX_SUBPKG_INCLUDE"
			TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$TERMUX_SUBPKG_PLATFORM_INDEPENDENT
			TERMUX_SUBPKG_DEPEND_ON_PARENT=no
			TERMUX_SUBPKG_VERSION=$TERMUX_SUBPKG_VERSION
			EOF
		fi
		
		PYTHON_PKGS_OK+=( $PYTHON_PKG )
	done
}

termux_step_configure() { :; }

termux_step_make() { :; }

termux_step_make_install() { :; }

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/lib/librt.so $TERMUX_PREFIX/lib/libpthread.so
}

termux_step_install_license() { :; }
