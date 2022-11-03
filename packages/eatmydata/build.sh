TERMUX_PKG_HOMEPAGE=https://www.flamingspork.com/projects/libeatmydata/
TERMUX_PKG_DESCRIPTION="Library and utilities designed to disable fsync and friends"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=130
TERMUX_PKG_SHA256=48731cd7e612ff73fd6339378fbbff38dd3bcf6c243593b0d9773ca0051541c0
TERMUX_PKG_SRCURL=https://github.com/stewartsmith/libeatmydata/releases/download/v${TERMUX_PKG_VERSION}/libeatmydata-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sed -i -e '/pthread_testcancel/d' libeatmydata/libeatmydata.c
}
