// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "swift-adwaita",
    products: [
        .library(
            name: "Adwaita",
            targets: ["Adwaita"]
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
            dependencies: ["CAdwaita"],
            swiftSettings: [
                .enableExperimentalFeature("IsolatedDeinit")
            ]
        ),
        .target(
            name: "Adwaita",
            dependencies: ["GObjectSupport", "CGtkSource"],
            swiftSettings: [
                .enableExperimentalFeature("IsolatedDeinit")
            ]
        ),
        .executableTarget(
            name: "DemoApp",
            dependencies: ["Adwaita"],
            path: "Sources/DemoApp",
            resources: [
                .copy("Resources")
            ]
        ),
        .testTarget(
            name: "AdwaitaTests",
            dependencies: ["Adwaita"]
        )
    ]
)
