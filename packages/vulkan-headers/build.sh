TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-Headers
TERMUX_PKG_DESCRIPTION="Vulkan Header files and API registry"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.295"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-Headers/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d4cf25d1dd305ad9d9a52afca035df72dde51916c7b3589a229e64fa651359d3
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
# Requires clang-scan-deps for building c++ module
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DVULKAN_HEADERS_ENABLE_MODULE=OFF
"
