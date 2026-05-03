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
        .target(
            name: "GObjectSupport",
            dependencies: ["CAdwaita"]
        ),
        .target(
            name: "Adwaita",
            dependencies: ["GObjectSupport", "CGtkSource"]
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
