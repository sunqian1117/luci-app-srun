#!/bin/bash
# Build script to create IPK package without OpenWrt SDK
# This creates a simple IPK that can be installed on OpenWrt

set -e

PKG_NAME="luci-app-srun"
PKG_VERSION="1.0.0"
PKG_RELEASE="1"
PKG_ARCH="all"
BUILD_DIR="build"
IPK_DIR="${BUILD_DIR}/ipk"
DATA_DIR="${IPK_DIR}/data"
CONTROL_DIR="${IPK_DIR}/control"

echo "=== Building ${PKG_NAME} IPK Package ==="

# Clean and create build directories
rm -rf "${BUILD_DIR}"
mkdir -p "${DATA_DIR}"
mkdir -p "${CONTROL_DIR}"

# Copy package files to data directory
echo "Copying package files..."
cp -r root/* "${DATA_DIR}/"
mkdir -p "${DATA_DIR}/usr/lib/lua/luci"
cp -r luasrc/* "${DATA_DIR}/usr/lib/lua/luci/"

# Set correct permissions
echo "Setting permissions..."
chmod 755 "${DATA_DIR}/usr/bin/srun-auth"
chmod 755 "${DATA_DIR}/usr/lib/srun/crypto.sh"
chmod 755 "${DATA_DIR}/etc/init.d/srun"
chmod 755 "${DATA_DIR}/etc/hotplug.d/iface/99-srun"
chmod 644 "${DATA_DIR}/etc/config/srun"

# Calculate installed size
INSTALLED_SIZE=$(du -sb "${DATA_DIR}" | cut -f1)

# Create control file
echo "Creating control file..."
cat > "${CONTROL_DIR}/control" << EOF
Package: ${PKG_NAME}
Version: ${PKG_VERSION}-${PKG_RELEASE}
Depends: curl, jsonfilter, coreutils-base64, openssl-util
Section: luci
Architecture: ${PKG_ARCH}
Installed-Size: ${INSTALLED_SIZE}
Maintainer: sunqian1117
Description: LuCI Support for Srun Authentication
 OpenWrt platform Srun campus network authentication client
 with automatic login, disconnection reconnection and Web UI.
EOF

# Create postinst script
cat > "${CONTROL_DIR}/postinst" << 'EOF'
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
    /etc/init.d/srun enable
    echo "Srun authentication client installed successfully!"
    echo "Please configure /etc/config/srun and run: /etc/init.d/srun start"
}
exit 0
EOF
chmod 755 "${CONTROL_DIR}/postinst"

# Create prerm script
cat > "${CONTROL_DIR}/prerm" << 'EOF'
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
    /etc/init.d/srun stop
    /etc/init.d/srun disable
}
exit 0
EOF
chmod 755 "${CONTROL_DIR}/prerm"

# Build IPK package
echo "Building IPK package..."
cd "${BUILD_DIR}"

# Create data.tar.gz
tar czf data.tar.gz -C ipk/data .

# Create control.tar.gz
tar czf control.tar.gz -C ipk/control .

# Create debian-binary
echo "2.0" > debian-binary

# Create final IPK using ar (proper IPK/DEB format)
IPK_FILENAME="../${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_${PKG_ARCH}.ipk"
ar r "${IPK_FILENAME}" debian-binary control.tar.gz data.tar.gz 2>/dev/null

cd ..

echo "=== Build Complete ==="
echo "Package created: ${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_${PKG_ARCH}.ipk"
echo ""
echo "To install on OpenWrt:"
echo "1. Upload the .ipk file to your router"
echo "2. Run: opkg install ${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_${PKG_ARCH}.ipk"
