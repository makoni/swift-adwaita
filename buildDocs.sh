#!/bin/bash

swift package --allow-writing-to-directory ~/Downloads \
    generate-documentation \
    --target Adwaita \
    --disable-indexing \
    --output-path ~/Downloads/adwaita \
    --transform-for-static-hosting \
    --hosting-base-path docs/adwaita
