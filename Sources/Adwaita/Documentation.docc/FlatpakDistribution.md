# Flatpak Distribution

Package and distribute your swift-adwaita application as a Flatpak.

## Overview

[Flatpak](https://flatpak.org) is the recommended way to distribute GTK4/libadwaita
applications on Linux. The GNOME runtime provides GTK4 and libadwaita at runtime,
and the Swift SDK extension provides the compiler at build time — your app ships
only its own binary.

This guide walks you through creating a Flatpak manifest, building your app, and
preparing it for distribution on Flathub.

> Flatpak is Linux-only. For the macOS workflow — packaging the same app as a
> regular `.app` bundle via Xcode — see `examples/macos/DemoApp/` in the
> repository.

### Prerequisites

Install `flatpak-builder` on your system:

```bash
# Ubuntu/Debian
sudo apt install flatpak-builder

# Fedora
sudo dnf install flatpak-builder
```

Install the GNOME SDK and Swift extension from Flathub:

```bash
flatpak install flathub org.gnome.Sdk//48 org.freedesktop.Sdk.Extension.swift6//24.08
```

The GNOME 48 runtime includes libadwaita 1.7. The Swift SDK extension (based on
freedesktop 24.08) provides Swift 6.2.

### Project structure

A Flatpak app needs four files beyond your Swift source code:

- **Manifest** (`com.example.MyApp.yml`) — build instructions for flatpak-builder
- **Desktop entry** (`com.example.MyApp.desktop`) — so the app appears in GNOME Shell
- **AppStream metadata** (`com.example.MyApp.metainfo.xml`) — description, screenshots, releases
- **App icon** (`com.example.MyApp.svg`) — scalable icon for the launcher

Place these in a `flatpak/` directory at the root of your project.

### Flatpak manifest

Create `flatpak/com.example.MyApp.yml`:

```yaml
app-id: com.example.MyApp
runtime: org.gnome.Platform
runtime-version: "48"
sdk: org.gnome.Sdk
sdk-extensions:
  - org.freedesktop.Sdk.Extension.swift6
command: MyApp

finish-args:
  - --share=ipc
  - --socket=fallback-x11
  - --socket=wayland
  - --device=dri

build-options:
  append-path: /usr/lib/sdk/swift6/bin
  prepend-ld-library-path: /usr/lib/sdk/swift6/lib

modules:
  - name: MyApp
    buildsystem: simple
    sources:
      - type: dir
        path: ..
    build-commands:
      - swift build -c release --product MyApp --static-swift-stdlib
      - install -Dm755 .build/release/MyApp /app/bin/MyApp
      - install -Dm644 flatpak/com.example.MyApp.desktop /app/share/applications/com.example.MyApp.desktop
      - install -Dm644 flatpak/com.example.MyApp.metainfo.xml /app/share/metainfo/com.example.MyApp.metainfo.xml
      - install -Dm644 flatpak/com.example.MyApp.svg /app/share/icons/hicolor/scalable/apps/com.example.MyApp.svg
```

Key points:

- `--static-swift-stdlib` links the Swift runtime statically into the binary, so the
  SDK extension is only needed at build time — not at runtime.
- The `command` field must match the executable product name in your `Package.swift`.
- `sources.path: ..` assumes the manifest lives in a `flatpak/` subdirectory.

### Desktop entry

Create `flatpak/com.example.MyApp.desktop`:

```ini
[Desktop Entry]
Name=My App
Comment=A GTK4/libadwaita app built with Swift
Exec=MyApp
Icon=com.example.MyApp
Terminal=false
Type=Application
Categories=GNOME;GTK;Utility;
```

### AppStream metadata

Create `flatpak/com.example.MyApp.metainfo.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<component type="desktop-application">
  <id>com.example.MyApp</id>
  <name>My App</name>
  <summary>A GTK4/libadwaita application built with Swift</summary>
  <metadata_license>CC0-1.0</metadata_license>
  <project_license>MIT</project_license>
  <description>
    <p>Describe your application here.</p>
  </description>
  <launchable type="desktop-id">com.example.MyApp.desktop</launchable>
  <url type="homepage">https://github.com/yourname/myapp</url>
  <releases>
    <release version="1.0.0" date="2025-01-01">
      <description><p>Initial release.</p></description>
    </release>
  </releases>
  <content_rating type="oars-1.1"/>
</component>
```

### App icon

Provide a scalable SVG icon at `flatpak/com.example.MyApp.svg`. GNOME HIG
recommends a 128x128 viewBox with 16px corner radius on the background shape.

### Build and run

Build the Flatpak locally:

```bash
flatpak-builder --force-clean --user --install build-dir flatpak/com.example.MyApp.yml
```

Run it:

```bash
flatpak run com.example.MyApp
```

The first build downloads and caches the SDK and runtime. Subsequent builds are
incremental and much faster.

### Application ID conventions

Your app ID must use reverse-DNS notation (e.g., `com.example.MyApp`). This ID is
used consistently across:

- The Flatpak manifest (`app-id`)
- The ``Application`` initializer: `Application(id: "com.example.MyApp")`
- The desktop entry filename
- The metainfo filename
- The icon filename

These must all match for the desktop environment to correctly associate your app's
icon, name, and metadata.

### Tips for production

- **D-Bus access**: If your app needs D-Bus services (e.g., notifications, portals),
  add `--socket=session-bus` or use specific `--talk-name=` permissions.
- **File access**: Use the FileDialog portal (already integrated in swift-adwaita)
  rather than `--filesystem=` permissions when possible.
- **Network access**: Add `--share=network` only if your app needs internet access.
- **`WebView`**: WebKitGTK 6.0 ships in `org.gnome.Platform>=46` — no extra
  module is required. If you target an older platform, add a `webkitgtk`
  module yourself or upgrade the runtime version.
- **Flathub submission**: See [Flathub's submission guide](https://docs.flathub.org/docs/for-app-authors/submission)
  for requirements on metadata, screenshots, and review process.

### DemoApp example

The swift-adwaita repository includes a complete Flatpak setup for the included
DemoApp in the `flatpak/` directory. Build and run it with:

```bash
flatpak-builder --force-clean --user --install build-dir flatpak/io.github.makoni.SwiftAdwaitaDemo.yml
flatpak run io.github.makoni.SwiftAdwaitaDemo
```
