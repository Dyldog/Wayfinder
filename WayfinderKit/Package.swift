// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WayfinderKit",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WayfinderKit",
            targets: ["WayfinderKit"]),
    ],
    dependencies: [
        .package(name: "DylKit", path: "../../DylKit")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WayfinderKit",
            dependencies: ["DylKit"]),
        .testTarget(
            name: "WayfinderKitTests",
            dependencies: ["WayfinderKit"]),
    ]
)
