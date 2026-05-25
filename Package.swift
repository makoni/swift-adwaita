// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-adwaita",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Adwaita",
            targets: ["Adwaita"]
        ),
        // Opt-in WebKitGTK integration. Consumers who want the
        // ``WebView`` widget add this product to their target's
        // dependencies; everyone else is not forced to install
        // `libwebkitgtk-6.0-dev` (which is unavailable on macOS
        // Homebrew, breaking that platform's build otherwise).
        .library(
            name: "AdwaitaWebKit",
            targets: ["AdwaitaWebKit"]
        ),
        .library(
            name: "DemoAppLib",
            targets: ["DemoAppLib"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin.git", from: "1.3.0")
    ],
    targets: [
        .systemLibrary(
            name: "CAdwaita",
            pkgConfig: "libadwaita-1",
            providers: [
                .apt(["libadwaita-1-dev"])
            ]
        ),
        .systemLibrary(
            name: "CGtkSource",
            pkgConfig: "gtksourceview-5",
            providers: [
                .apt(["libgtksourceview-5-dev"])
            ]
        ),
        .systemLibrary(
            name: "CWebKit",
            pkgConfig: "webkitgtk-6.0",
            providers: [
                .apt(["libwebkitgtk-6.0-dev"])
            ]
        ),
        .target(
            name: "GObjectSupport",
            dependencies: ["CAdwaita"]
        ),
        .target(
            name: "Adwaita",
            dependencies: ["GObjectSupport", "CGtkSource"]
        ),
        // WebView lives in its own target so the WebKitGTK system
        // dependency stays opt-in. Importing this module pulls in
        // CWebKit (and therefore requires `libwebkitgtk-6.0-dev` on
        // apt / `webkitgtk-6.0` pkg-config on the system).
        .target(
            name: "AdwaitaWebKit",
            dependencies: ["Adwaita", "CWebKit"]
        ),
        .target(
            name: "DemoAppLib",
            dependencies: ["Adwaita"],
            path: "Sources/DemoAppLib",
            resources: [
                .copy("Resources")
            ]
        ),
        .executableTarget(
            name: "DemoApp",
            dependencies: ["DemoAppLib"],
            path: "Sources/DemoApp"
        ),
        .testTarget(
            name: "AdwaitaTests",
            dependencies: ["Adwaita"]
        )
    ]
)
