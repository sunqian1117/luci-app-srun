#!/bin/bash
# Build script for creating luci-app-srun IPK package

set -e

PACKAGE_NAME="luci-app-srun"
VERSION="1.0.0"
RELEASE="1"
ARCH="all"
PKG_DIR="${PACKAGE_NAME}_${VERSION}-${RELEASE}_${ARCH}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "====================================="
echo "Building ${PACKAGE_NAME} IPK package"
echo "====================================="

# Create temporary build directory
BUILD_DIR="/tmp/${PKG_DIR}"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Create package directory structure
echo "Creating package directory structure..."
mkdir -p "$BUILD_DIR/CONTROL"
mkdir -p "$BUILD_DIR/data"

# Create control file
echo "Creating control file..."
cat > "$BUILD_DIR/CONTROL/control" << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}-${RELEASE}
Architecture: ${ARCH}
Maintainer: sunqian1117
Section: luci
Priority: optional
Depends: curl, jsonfilter, coreutils-base64, openssl-util
Description: LuCI Support for Srun Campus Network Authentication
 OpenWrt platform Srun campus network authentication client with
 automatic login, reconnection, and Web interface configuration.
EOF

# Create postinst script
echo "Creating postinst script..."
cat > "$BUILD_DIR/CONTROL/postinst" << 'EOF'
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
    ( . /etc/uci-defaults/luci-srun ) && rm -f /etc/uci-defaults/luci-srun
    /etc/init.d/srun enable
    /etc/init.d/rpcd restart
}
exit 0
EOF

chmod +x "$BUILD_DIR/CONTROL/postinst"

# Create prerm script
echo "Creating prerm script..."
cat > "$BUILD_DIR/CONTROL/prerm" << 'EOF'
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
    /etc/init.d/srun stop
    /etc/init.d/srun disable
}
exit 0
EOF

chmod +x "$BUILD_DIR/CONTROL/prerm"

# Copy package files if they exist
if [ -d "$SCRIPT_DIR/root" ]; then
    echo "Copying root files..."
    cp -r "$SCRIPT_DIR/root"/* "$BUILD_DIR/data/"
else
    echo "Warning: root directory not found, creating minimal structure..."
    mkdir -p "$BUILD_DIR/data/etc/config"
    mkdir -p "$BUILD_DIR/data/etc/init.d"
    mkdir -p "$BUILD_DIR/data/usr/bin"
    mkdir -p "$BUILD_DIR/data/usr/lib/srun"
fi

if [ -d "$SCRIPT_DIR/luasrc" ]; then
    echo "Copying LuCI files..."
    mkdir -p "$BUILD_DIR/data/usr/lib/lua/luci"
    cp -r "$SCRIPT_DIR/luasrc"/* "$BUILD_DIR/data/usr/lib/lua/luci/"
else
    echo "Warning: luasrc directory not found"
fi

# Set proper permissions
echo "Setting permissions..."
find "$BUILD_DIR/data/usr/bin" -type f -exec chmod +x {} \; 2>/dev/null || true
find "$BUILD_DIR/data/etc/init.d" -type f -exec chmod +x {} \; 2>/dev/null || true
find "$BUILD_DIR/data/usr/lib/srun" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Create data.tar.gz
echo "Creating data.tar.gz..."
cd "$BUILD_DIR/data"
tar czf ../data.tar.gz ./*
cd ..

# Create control.tar.gz
echo "Creating control.tar.gz..."
cd "$BUILD_DIR/CONTROL"
tar czf ../control.tar.gz ./*
cd ..

# Create debian-binary
echo "Creating debian-binary..."
echo "2.0" > "$BUILD_DIR/debian-binary"

# Create IPK file
OUTPUT_DIR="$SCRIPT_DIR/bin"
mkdir -p "$OUTPUT_DIR"
IPK_FILE="${OUTPUT_DIR}/${PKG_DIR}.ipk"

echo "Creating IPK package..."
cd "$BUILD_DIR"
# Use ar to create IPK in proper format (ar archive)
ar r "$IPK_FILE" debian-binary data.tar.gz control.tar.gz

# Cleanup
echo "Cleaning up..."
rm -rf "$BUILD_DIR"

echo ""
echo "====================================="
echo "✓ Package built successfully!"
echo "====================================="
echo "Package: $IPK_FILE"
echo ""
echo "Install on OpenWrt with:"
echo "  scp $IPK_FILE root@192.168.1.1:/tmp/"
echo "  ssh root@192.168.1.1 'opkg install /tmp/$(basename $IPK_FILE)'"
echo ""
