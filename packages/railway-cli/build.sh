TERMUX_PKG_HOMEPAGE=https://railway.app
TERMUX_PKG_DESCRIPTION="This is the command line interface for Railway"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.12"
TERMUX_PKG_SRCURL=https://github.com/railwayapp/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ba4183b0a7c59d4b381bc0bb9ea70700d773775cf387c5d3fab54f22a3fba304
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go build -ldflags="-s -w -X github.com/railwayapp/cli/constants.Version=${TERMUX_PKG_VERSION}" -o bin/railway
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin bin/railway
}
