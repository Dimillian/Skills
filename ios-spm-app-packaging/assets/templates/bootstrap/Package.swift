// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "MyApp", targets: ["MyApp"])
    ],
    targets: [
        .target(
            name: "MyApp",
            path: "Sources/MyApp",
            resources: [.process("Resources")]
        )
    ]
)
