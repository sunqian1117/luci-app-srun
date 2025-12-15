# Copyright (C) 2024 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-srun
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=sunqian1117

LUCI_TITLE:=LuCI Support for Srun Authentication
LUCI_DEPENDS:=+curl +jsonfilter +coreutils-base64 +openssl-util
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
