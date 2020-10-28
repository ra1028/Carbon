// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Carbon",
    platforms: [
           .iOS(.v12),
           .watchOS(.v5)
    ],
    products: [
        .library(
            name: "Carbon",
            targets: ["Carbon"]),
    ],
    dependencies: [
         .package(url: "https://github.com/skymobilebuilds/DifferenceKit.git", from: "1.1.7"),
    ],
    targets: [
        .target(
            name: "Carbon",
            dependencies: ["DifferenceKit"]),
        .testTarget(
            name: "CarbonTests",
            dependencies: ["Carbon"]),
    ]
)
