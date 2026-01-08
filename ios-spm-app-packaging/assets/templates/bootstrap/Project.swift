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
                "UILaunchScreen": [:],
                "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
            ]),
            sources: ["Sources/MyApp/**"],
            resources: ["Sources/MyApp/Resources/**"],
            settings: .settings(
                base: [
                    "MARKETING_VERSION": "1.0.0",
                    "CURRENT_PROJECT_VERSION": "1",
                    "SWIFT_VERSION": "6.0"
                ],
                configurations: [
                    .debug(name: "Debug", settings: [
                        "CODE_SIGN_IDENTITY": "Apple Development"
                    ]),
                    .release(name: "Release", settings: [
                        "CODE_SIGN_IDENTITY": "Apple Distribution"
                    ]),
                    .release(name: "CI", settings: [
                        "CODE_SIGNING_REQUIRED": "NO",
                        "CODE_SIGNING_ALLOWED": "NO",
                        "CODE_SIGN_IDENTITY": ""
                    ])
                ]
            )
        )
    ],
    schemes: [
        .scheme(
            name: "MyApp",
            buildAction: .buildAction(targets: ["MyApp"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
        .scheme(
            name: "MyApp-CI",
            buildAction: .buildAction(targets: ["MyApp"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "CI")
        )
    ]
)
