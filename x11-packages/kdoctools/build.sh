TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Tools to generate documentation in various formats from DocBook"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/kdoctools/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c3909c7a84282c9f21d064880a375d651f41cba151a0a2b8f5e2e301b9d22bdc
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, karchive, ki18n, libxml2, libxls, docbook-xml, docbook-xsl"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
_TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDOCBOOKL10NHELPER_EXECUTABLE=true
-DMEINPROC5_EXECUTABLE=meinproc5
-DCHECKXML5_EXECUTABLE=checkXML5
"

# kdoctools5 for meinproc5 checkXML5

_termux_step_host_build() {
    mkdir $TERMUX_PKG_BUILDDIR/bin
    cd $TERMUX_PREFIX/include/QtCore
	g++ $TERMUX_PKG_SRCDIR/src/docbookl10nhelper.cpp -o $TERMUX_PKG_BUILDDIR/bin/docbookl10nhelper
}

termux_step_pre_configure() {
	# FIXME docbookl10nhelper doesn't work
    mkdir -p $TERMUX_PKG_BUILDDIR/src/customization/xsl
    sed -e "s|\"/usr/share/|\"$TERMUX_PREFIX/share/|" /usr/share/kf5/kdoctools/customization/xsl/all-l10n.xml \
        > $TERMUX_PKG_BUILDDIR/src/customization/xsl/all-l10n.xml
}
