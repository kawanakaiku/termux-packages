TERMUX_PKG_HOMEPAGE=https://bazel.build/
TERMUX_PKG_DESCRIPTION="Tool to automate software builds and tests"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.1
TERMUX_PKG_SRCURL=https://github.com/bazelbuild/bazel/releases/download/${TERMUX_PKG_VERSION}/bazel-${TERMUX_PKG_VERSION}-dist.zip
TERMUX_PKG_SHA256=18486e7152ca26b26585e9b2a6f49f332b116310d3b7e5b70583f1f1f24bb8ae
TERMUX_PKG_BUILD_DEPENDS=openjdk-11
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
  local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
  termux_download "$TERMUX_PKG_SRCURL" "$file" "$TERMUX_PKG_SHA256"
  mkdir "$TERMUX_PKG_SRCDIR"
  unzip -q "$file" -d "$TERMUX_PKG_SRCDIR"
}

termux_step_make() {
  if $TERMUX_ON_DEVICE_BUILD; then
    unset JAVA_HOME
  fi
  env EXTRA_BAZEL_ARGS="--tool_java_runtime_version=local_jdk" bash ./compile.sh
}

termux_step_make_install() {
  install -m 755 output/bazel ${TERMUX_PREFIX}/bin/bazel
}
