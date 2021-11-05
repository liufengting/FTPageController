// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "FTPageController",
    platforms: [ .iOS(.v12), .macOS(.v10_14)],
    products: [
        .library(name: "FTPageController", targets: ["FTPageController"]),
    ],
    targets: [
        .target(name: "FTPageController", path: "FTPageController/")
    ],
    swiftLanguageVersions: [.v5]
)
