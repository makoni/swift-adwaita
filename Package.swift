// swift-tools-version: 6.0

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
        .target(
            name: "GObjectSupport",
            dependencies: ["CAdwaita"]
        ),
        .target(
            name: "Adwaita",
            dependencies: ["GObjectSupport"]
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
