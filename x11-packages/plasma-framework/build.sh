TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Plasma library and runtime components based upon KF5 and Qt5"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.102.0
TERMUX_PKG_SRCURL=https://github.com/KDE/plasma-framework/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=50f0f82ddc27de47e8100e2f9f15993867e8e8dc88e43188ffc54438c280f8c4
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtdeclarative, qt5-qtsvg, qt5-qtquickcontrols2, pulseaudio, libcanberra, libdbusmenu-qt, kactivities, kdbusaddons, kdeclarative, kxmlgui, knotifications, kpackage, kirigami2, kdoctools, kio"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

<<'#'
-- Installing in the same prefix as Qt, adopting their path scheme.
-- Looking for __GLIBC__
-- Looking for __GLIBC__ - not found
-- Performing Test _OFFT_IS_64BIT
-- Performing Test _OFFT_IS_64BIT - Success
-- Performing Test HAVE_DATE_TIME
-- Performing Test HAVE_DATE_TIME - Success
-- Performing Test BSYMBOLICFUNCTIONS_AVAILABLE
-- Performing Test BSYMBOLICFUNCTIONS_AVAILABLE - Success
-- Could NOT find KF5Activities (missing: KF5Activities_DIR)
-- Could NOT find KF5Activities: found neither KF5ActivitiesConfig.cmake nor kf5activities-config.cmake 
-- Could NOT find KF5Archive (missing: KF5Archive_DIR)
-- Could NOT find KF5Archive: found neither KF5ArchiveConfig.cmake nor kf5archive-config.cmake 
-- Could NOT find KF5Config (missing: KF5Config_DIR)
-- Could NOT find KF5Config: found neither KF5ConfigConfig.cmake nor kf5config-config.cmake 
-- Could NOT find KF5ConfigWidgets (missing: KF5ConfigWidgets_DIR)
-- Could NOT find KF5ConfigWidgets: found neither KF5ConfigWidgetsConfig.cmake nor kf5configwidgets-config.cmake 
-- Could NOT find KF5CoreAddons (missing: KF5CoreAddons_DIR)
-- Could NOT find KF5CoreAddons: found neither KF5CoreAddonsConfig.cmake nor kf5coreaddons-config.cmake 
-- Could NOT find KF5DBusAddons (missing: KF5DBusAddons_DIR)
-- Could NOT find KF5DBusAddons: found neither KF5DBusAddonsConfig.cmake nor kf5dbusaddons-config.cmake 
-- Could NOT find KF5Declarative (missing: KF5Declarative_DIR)
-- Could NOT find KF5Declarative: found neither KF5DeclarativeConfig.cmake nor kf5declarative-config.cmake 
-- Could NOT find KF5GlobalAccel (missing: KF5GlobalAccel_DIR)
-- Could NOT find KF5GlobalAccel: found neither KF5GlobalAccelConfig.cmake nor kf5globalaccel-config.cmake 
-- Could NOT find KF5GuiAddons (missing: KF5GuiAddons_DIR)
-- Could NOT find KF5GuiAddons: found neither KF5GuiAddonsConfig.cmake nor kf5guiaddons-config.cmake 
-- Could NOT find KF5I18n (missing: KF5I18n_DIR)
-- Could NOT find KF5I18n: found neither KF5I18nConfig.cmake nor kf5i18n-config.cmake 
-- Could NOT find KF5IconThemes (missing: KF5IconThemes_DIR)
-- Could NOT find KF5IconThemes: found neither KF5IconThemesConfig.cmake nor kf5iconthemes-config.cmake 
-- Could NOT find KF5KIO (missing: KF5KIO_DIR)
-- Could NOT find KF5KIO: found neither KF5KIOConfig.cmake nor kf5kio-config.cmake 
-- Could NOT find KF5WindowSystem (missing: KF5WindowSystem_DIR)
-- Could NOT find KF5WindowSystem: found neither KF5WindowSystemConfig.cmake nor kf5windowsystem-config.cmake 
-- Could NOT find KF5XmlGui (missing: KF5XmlGui_DIR)
-- Could NOT find KF5XmlGui: found neither KF5XmlGuiConfig.cmake nor kf5xmlgui-config.cmake 
-- Could NOT find KF5Notifications (missing: KF5Notifications_DIR)
-- Could NOT find KF5Notifications: found neither KF5NotificationsConfig.cmake nor kf5notifications-config.cmake 
-- Could NOT find KF5Package (missing: KF5Package_DIR)
-- Could NOT find KF5Package: found neither KF5PackageConfig.cmake nor kf5package-config.cmake 
-- Could NOT find KF5Kirigami2 (missing: KF5Kirigami2_DIR)
-- Could NOT find KF5Kirigami2: found neither KF5Kirigami2Config.cmake nor kf5kirigami2-config.cmake 
-- Could NOT find KF5Wayland (missing: KF5Wayland_DIR)
-- Could NOT find KF5Wayland: found neither KF5WaylandConfig.cmake nor kf5wayland-config.cmake 
-- Could NOT find KF5DocTools (missing: KF5DocTools_DIR)
-- Could NOT find KF5DocTools: found neither KF5DocToolsConfig.cmake nor kf5doctools-config.cmake
#

termux_step_pre_configure() {
	CXXFLAGS+=" -DQ_OS_ANDROID"

    _KDOCTOOLS_EXIST=false
    if test -d $TERMUX_PREFIX/lib/cmake/KF5DocTools; then
        _KDOCTOOLS_EXIST=true
        mv $TERMUX_PREFIX/lib/cmake/{,_}KF5DocTools
    fi

    local f=/usr/lib/libexec/kf5/kconfig_compiler_kf5
    if ! test -f $f; then
        echo "$f doesn't exist."
        return 1
    fi
    mv $TERMUX_PREFIX/lib/libexec/kf5/kconfig_compiler_kf5{,.bak}
    ln -s $f $TERMUX_PREFIX/lib/libexec/kf5/kconfig_compiler_kf5
}

termux_step_post_make_install() {
    if $_KDOCTOOLS_EXIST; then
        mv $TERMUX_PREFIX/lib/cmake/{_,}KF5DocTools
    fi

    mv $TERMUX_PREFIX/lib/libexec/kf5/kconfig_compiler_kf5{.bak,}
}
