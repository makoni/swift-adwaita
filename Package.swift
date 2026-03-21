// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-adwaita",
    products: [
        .library(
            name: "Adwaita",
            targets: ["Adwaita"]
        ),
    ],
    targets: [
        .systemLibrary(
            name: "CAdwaita",
            pkgConfig: "libadwaita-1",
            providers: [
                .apt(["libadwaita-1-dev"]),
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
        .testTarget(
            name: "AdwaitaTests",
            dependencies: ["Adwaita"]
        ),
    ]
)
