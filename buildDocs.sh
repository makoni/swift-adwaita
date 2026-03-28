#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="Adwaita"
HTML_DIR="${SCRIPT_DIR}/docs-html"
MD_ARCHIVE="${SCRIPT_DIR}/.build/docs-md-archive"
MD_DIR="${SCRIPT_DIR}/docs"

echo "=== Building documentation for ${TARGET} ==="

# 1. HTML for static hosting
echo ""
echo "--- Generating HTML documentation ---"
rm -rf "${HTML_DIR}"

swift package --allow-writing-to-directory "${HTML_DIR}" \
    generate-documentation \
    --target "${TARGET}" \
    --disable-indexing \
    --output-path "${HTML_DIR}" \
    --transform-for-static-hosting \
    --hosting-base-path swift-adwaita

echo "HTML docs: ${HTML_DIR}"

# 2. Markdown for the repository
echo ""
echo "--- Generating Markdown documentation ---"
rm -rf "${MD_ARCHIVE}"

swift package --allow-writing-to-directory "${MD_ARCHIVE}" \
    generate-documentation \
    --target "${TARGET}" \
    --disable-indexing \
    --output-path "${MD_ARCHIVE}" \
    --enable-experimental-markdown-output \
    --enable-experimental-markdown-output-manifest

# Copy markdown files from the archive into docs/
rm -rf "${MD_DIR}"
mkdir -p "${MD_DIR}"

ARCHIVE_DATA="${MD_ARCHIVE}/data/documentation"
if [ -d "${ARCHIVE_DATA}" ]; then
    cp -r "${ARCHIVE_DATA}/"* "${MD_DIR}/"
fi

# Copy the manifest if generated
MANIFEST="${MD_ARCHIVE}/${TARGET}-markdown-manifest.json"
if [ -f "${MANIFEST}" ]; then
    cp "${MANIFEST}" "${MD_DIR}/manifest.json"
fi

# Clean up the intermediate archive
rm -rf "${MD_ARCHIVE}"

MD_COUNT=$(find "${MD_DIR}" -name '*.md' | wc -l)
echo "Markdown docs: ${MD_DIR} (${MD_COUNT} pages)"

echo ""
echo "=== Done ==="
