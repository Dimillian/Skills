# Scaffold a SwiftPM iOS app (Tuist)

## Steps

1) Create a repo and initialize SwiftPM:
```
mkdir MyApp
cd MyApp
swift package init --type library
```

2) Create `Project.swift` for Tuist (see template below).

3) Create the app entry point under `Sources/MyApp/`.
   - Use SwiftUI with `@main` App struct.

4) Add resources directory:
```
mkdir -p Sources/MyApp/Resources
```

5) Install Tuist and generate project:
```
brew install --cask tuist
tuist generate
open MyApp.xcodeproj
```

6) Add generated files to `.gitignore`:
```
echo "*.xcodeproj" >> .gitignore
echo ".tuist-derived/" >> .gitignore
```

## Minimal Package.swift

```swift
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
```

## Minimal Project.swift (Tuist)

```swift
import ProjectDescription

let project = Project(
    name: "MyApp",
    targets: [
        .target(
            name: "MyApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.example.myapp",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:]
            ]),
            sources: ["Sources/MyApp/**"],
            resources: ["Sources/MyApp/Resources/**"],
            settings: .settings(base: [
                "MARKETING_VERSION": "1.0.0",
                "CURRENT_PROJECT_VERSION": "1",
                "SWIFT_VERSION": "6.0"
            ])
        )
    ]
)
```

## Minimal SwiftUI entry point

```swift
import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello")
    }
}
```

## Adding SPM dependencies

In `Project.swift`, add packages and dependencies:

```swift
let project = Project(
    name: "MyApp",
    packages: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "MyApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.example.myapp",
            sources: ["Sources/MyApp/**"],
            dependencies: [
                .package(product: "Alamofire")
            ]
        )
    ]
)
```
