#!/bin/bash
# Simple PCL to PDF converter using gpcl6-working

if [ -z "$1" ]; then
    echo "Usage: $0 input.spl [output.pdf]"
    exit 1
fi

INPUT_FILE="$1"

# Generate output filename
if [ -n "$2" ]; then
    OUTPUT_FILE="$2"
else
    # Remove any existing extension and add .pdf
    BASENAME="${INPUT_FILE%.*}"
    OUTPUT_FILE="${BASENAME}.pdf"
fi

# Check for gpcl6-working
GPCL6="$HOME/.local/bin/gpcl6-working"

if [ ! -f "$GPCL6" ]; then
    echo "❌ gpcl6-working not found at: $GPCL6"
    echo ""
    echo "Install it first:"
    echo "  ./install_working_ghostpcl.sh"
    exit 1
fi

if [ ! -x "$GPCL6" ]; then
    echo "❌ gpcl6-working is not executable"
    chmod +x "$GPCL6"
fi

echo "Converting PCL to PDF..."
echo "Input:  $INPUT_FILE"
echo "Output: $OUTPUT_FILE"
echo ""

"$GPCL6" \
  -dNOPAUSE \
  -dBATCH \
  -dSAFER \
  -sDEVICE=pdfwrite \
  -sPAPERSIZE=letter \
  -r600 \
  -sOutputFile="$OUTPUT_FILE" \
  "$INPUT_FILE"

RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo ""
    echo "✓ Conversion successful!"
    ls -lh "$OUTPUT_FILE"
    echo ""
    echo "Open it with: open \"$OUTPUT_FILE\""
else
    echo ""
    echo "❌ Conversion failed with exit code: $RESULT"
    echo ""
    echo "If you see security warnings about an unidentified developer, run:"
    echo "  xattr -d com.apple.quarantine $GPCL6"
    echo "  sudo xattr -cr $GPCL6"
fi

exit $RESULT
