// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavigationBarKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "NavigationBarKit",
            targets: ["NavigationBarKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NavigationBarKit",
            dependencies: [],
            path: "Codes",
            resources: [
                .process("../Assets")
            ]
        ),
    ]
)
