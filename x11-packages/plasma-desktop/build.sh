TERMUX_PKG_HOMEPAGE=https://invent.kde.org/plasma/plasma-desktop
TERMUX_PKG_DESCRIPTION="Plasma for the Desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.26.90
TERMUX_PKG_SRCURL=https://github.com/KDE/plasma-desktop/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=36bb0a599e6c5b5291d80901ad5ac3da19fd5ebe45ca3e9196bc6eab4ab8858a
TERMUX_PKG_DEPENDS="ecm, qt5-qtbase, qt5-qtdeclarative, qt5-qtsvg, qt5-qtx11extras, qt5-qtwayland, kauth, kcrash, plasma-framework, kdoctools, ki18n, kcodecs, kcoreaddons, kguiaddons, kconfig, kconfigwidgets, kwidgetsaddons, krunner, kactivities-stats, sonnet, kwayland, knotifyconfig, attica, kcmutils, kdelibs4support, kcompletion, knewstuff, kitemmodels, kinit, plasma-workspace, kwallet"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"

<<'#'
-- Could NOT find QtWaylandScanner (missing: QtWaylandScanner_EXECUTABLE) 
-- Found KF5Auth: /data/data/com.termux/files/usr/lib/cmake/KF5Auth/KF5AuthConfig.cmake (found version "5.102.0") 
-- Found KF5Crash: /data/data/com.termux/files/usr/lib/cmake/KF5Crash/KF5CrashConfig.cmake (found version "5.102.0") 
-- Could NOT find KF5Plasma (missing: KF5Plasma_DIR)
-- Could NOT find KF5Plasma: found neither KF5PlasmaConfig.cmake nor kf5plasma-config.cmake 
-- Could NOT find KF5PlasmaQuick (missing: KF5PlasmaQuick_DIR)
-- Could NOT find KF5PlasmaQuick: found neither KF5PlasmaQuickConfig.cmake nor kf5plasmaquick-config.cmake 
-- Could NOT find KF5DocTools (missing: KF5DocTools_DIR)
-- Could NOT find KF5DocTools: found neither KF5DocToolsConfig.cmake nor kf5doctools-config.cmake 
-- Found Gettext: /usr/bin/msgmerge (found version "0.21") 
-- Found KF5I18n: /data/data/com.termux/files/usr/lib/cmake/KF5I18n/KF5I18nConfig.cmake (found version "5.102.0") 
-- Could NOT find KF5KCMUtils (missing: KF5KCMUtils_DIR)
-- Could NOT find KF5KCMUtils: found neither KF5KCMUtilsConfig.cmake nor kf5kcmutils-config.cmake 
-- Could NOT find KF5NewStuff (missing: KF5NewStuff_DIR)
-- Could NOT find KF5NewStuff: found neither KF5NewStuffConfig.cmake nor kf5newstuff-config.cmake 
-- Could NOT find KF5NewStuffQuick (missing: KF5NewStuffQuick_DIR)
-- Could NOT find KF5NewStuffQuick: found neither KF5NewStuffQuickConfig.cmake nor kf5newstuffquick-config.cmake 
-- Could NOT find KF5KIO (missing: KF5KIO_DIR)
-- Could NOT find KF5KIO: found neither KF5KIOConfig.cmake nor kf5kio-config.cmake 
-- Could NOT find KF5Notifications (missing: KF5Notifications_DIR)
-- Could NOT find KF5Notifications: found neither KF5NotificationsConfig.cmake nor kf5notifications-config.cmake 
-- Could NOT find KF5NotifyConfig (missing: KF5NotifyConfig_DIR)
-- Could NOT find KF5NotifyConfig: found neither KF5NotifyConfigConfig.cmake nor kf5notifyconfig-config.cmake 
-- Could NOT find KF5Attica (missing: KF5Attica_DIR)
-- Could NOT find KF5Attica: found neither KF5AtticaConfig.cmake nor kf5attica-config.cmake 
-- Could NOT find KF5Runner (missing: KF5Runner_DIR)
-- Could NOT find KF5Runner: found neither KF5RunnerConfig.cmake nor kf5runner-config.cmake 
-- Could NOT find KF5GlobalAccel (missing: KF5GlobalAccel_DIR)
-- Could NOT find KF5GlobalAccel: found neither KF5GlobalAccelConfig.cmake nor kf5globalaccel-config.cmake 
-- Found KF5CoreAddons: /data/data/com.termux/files/usr/lib/cmake/KF5CoreAddons/KF5CoreAddonsConfig.cmake (found version "5.102.0") 
-- Found KF5GuiAddons: /data/data/com.termux/files/usr/lib/cmake/KF5GuiAddons/KF5GuiAddonsConfig.cmake (found version "5.102.0") 
-- Could NOT find KF5Declarative (missing: KF5Declarative_DIR)
-- Could NOT find KF5Declarative: found neither KF5DeclarativeConfig.cmake nor kf5declarative-config.cmake 
-- Could NOT find KF5DBusAddons (missing: KF5DBusAddons_DIR)
-- Could NOT find KF5DBusAddons: found neither KF5DBusAddonsConfig.cmake nor kf5dbusaddons-config.cmake 
-- Could NOT find KF5Activities (missing: KF5Activities_DIR)
-- Could NOT find KF5Activities: found neither KF5ActivitiesConfig.cmake nor kf5activities-config.cmake 
-- Could NOT find KF5ActivitiesStats (missing: KF5ActivitiesStats_DIR)
-- Could NOT find KF5ActivitiesStats: found neither KF5ActivitiesStatsConfig.cmake nor kf5activitiesstats-config.cmake 
-- Found KF5Config: /data/data/com.termux/files/usr/lib/cmake/KF5Config/KF5ConfigConfig.cmake (found version "5.102.0") 
-- Found KF5WidgetsAddons: /data/data/com.termux/files/usr/lib/cmake/KF5WidgetsAddons/KF5WidgetsAddonsConfig.cmake (found version "5.102.0") 
-- Found KF5Codecs: /data/data/com.termux/files/usr/lib/cmake/KF5Codecs/KF5CodecsConfig.cmake (found version "5.102.0") 
-- Could NOT find KF5Sonnet (missing: KF5Sonnet_DIR)
-- Could NOT find KF5Sonnet: found neither KF5SonnetConfig.cmake nor kf5sonnet-config.cmake 
-- Could NOT find KF5Package (missing: KF5Package_DIR)
-- Could NOT find KF5Package: found neither KF5PackageConfig.cmake nor kf5package-config.cmake 
CMake Error at /mnt/wwn-0x5000039983785083-part1/termux-build/_cache/cmake-3.25.2/share/cmake-3.25/Modules/FindPackageHandleStandardArgs.cmake:230 (message):
  Could NOT find KF5 (missing: Plasma PlasmaQuick DocTools KCMUtils NewStuff
  NewStuffQuick KIO Notifications NotifyConfig Attica Runner GlobalAccel
  Declarative DBusAddons Activities ActivitiesStats Sonnet Package) (found
  suitable version "5.102.0", minimum required is "5.98.0")
Call Stack (most recent call first):
  /mnt/wwn-0x5000039983785083-part1/termux-build/_cache/cmake-3.25.2/share/cmake-3.25/Modules/FindPackageHandleStandardArgs.cmake:600 (_FPHSA_FAILURE_MESSAGE)
  /data/data/com.termux/files/usr/share/ECM/find-modules/FindKF5.cmake:93 (find_package_handle_standard_args)
  CMakeLists.txt:51 (find_package)
#
