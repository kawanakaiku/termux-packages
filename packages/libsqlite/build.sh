TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
# Note: Updating this version requires bumping libsqlite-tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=39
_SQLITE_PATCH=4
_SQLITE_YEAR=2022
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_SRCURL=https://www.sqlite.org/${_SQLITE_YEAR}/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
TERMUX_PKG_SHA256=f31d445b48e67e284cf206717cc170ab63cbe4fd7f79a82793b772285e78fdbb
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BREAKS="libsqlite-dev"
TERMUX_PKG_REPLACES="libsqlite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-readline
--enable-fts3
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1"
	LDFLAGS+=" -lm"
}
