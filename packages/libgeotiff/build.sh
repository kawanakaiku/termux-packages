TERMUX_PKG_HOMEPAGE="https://github.com/OSGeo/libgeotiff"
TERMUX_PKG_DESCRIPTION="Library for handling TIFF for georeferenced raster imagery"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.1"
TERMUX_PKG_SRCURL="https://github.com/OSGeo/libgeotiff/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=09a0cae5352030011b994a60237743a1327ab95ce482318d45bf9fcb5e5f76b5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libtiff, proj, libsqlite, libjpeg-turbo, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_TIFF=ON
-DWITH_ZLIB=ON
-DWITH_JPEG=ON
-DWITH_TOWGS84=ON
-DBUILD_SHARED_LIBS=ON
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/libgeotiff"
}
