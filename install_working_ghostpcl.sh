#!/bin/bash
# Download and install working GhostPCL for macOS

echo "======================================================================"
echo "GhostPCL Installer for macOS (from mendelson.org)"
echo "======================================================================"
echo ""

INSTALL_DIR="$HOME/.local/bin"
DOWNLOAD_DIR="/tmp/ghostpcl_download"

mkdir -p "$INSTALL_DIR"
mkdir -p "$DOWNLOAD_DIR"

echo "Installation directory: $INSTALL_DIR"
echo ""

# Download the macOS binary (includes fonts, works on both Intel and ARM)
DOWNLOAD_URL="https://mendelson.org/GhostPCL-MacOS-Binary.zip"
FILENAME="GhostPCL-MacOS-Binary.zip"

echo "Downloading GhostPCL for macOS..."
echo "Source: mendelson.org (unofficial but working build)"
echo "URL: $DOWNLOAD_URL"
echo ""

cd "$DOWNLOAD_DIR"
curl -L -o "$FILENAME" "$DOWNLOAD_URL"

if [ $? -ne 0 ]; then
    echo "❌ Download failed"
    echo ""
    echo "You can download manually from:"
    echo "https://mendelson.org/ghostpcl.html"
    exit 1
fi

echo "✓ Download complete"
echo ""

echo "Extracting..."
unzip -q "$FILENAME"

if [ $? -ne 0 ]; then
    echo "❌ Extraction failed"
    exit 1
fi

echo "✓ Extraction complete"
echo ""

# Find the gpcl6 binary
BINARY_PATH=$(find . -name "gpcl6" -type f 2>/dev/null | head -1)

if [ -z "$BINARY_PATH" ]; then
    echo "❌ Could not find gpcl6 binary in archive"
    ls -la
    exit 1
fi

echo "Found binary: $BINARY_PATH"
echo ""

# Copy to install directory
cp "$BINARY_PATH" "$INSTALL_DIR/gpcl6-working"
chmod +x "$INSTALL_DIR/gpcl6-working"

echo "✓ Installed gpcl6-working to $INSTALL_DIR"
echo ""

# Test the binary
echo "Testing gpcl6-working..."
"$INSTALL_DIR/gpcl6-working" --version 2>&1 | head -10

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ SUCCESS! gpcl6-working is functioning"
else
    echo ""
    echo "⚠ Binary may need additional setup"
    echo ""
    echo "If you see security warnings, run:"
    echo "  xattr -d com.apple.quarantine $INSTALL_DIR/gpcl6-working"
fi

echo ""
echo "======================================================================"
echo "Installation complete!"
echo "======================================================================"
echo ""
echo "The working GhostPCL binary is installed as: gpcl6-working"
echo ""
echo "Add to PATH:"
echo "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.zshrc"
echo "  source ~/.zshrc"
echo ""
echo "Convert PCL to PDF:"
echo "  gpcl6-working -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \\"
echo "    -sPAPERSIZE=letter -r600 -sOutputFile=output.pdf input.spl"
echo ""
echo "Or use the wrapper script:"
echo "  ./convert_pcl.sh input.spl"
echo ""
echo "======================================================================"

# Cleanup
cd /
rm -rf "$DOWNLOAD_DIR"
