import ProjectDescription

let version = "1.0"
let buildNumber = 5

enum PlaceType: Equatable {
    case single(_ identifier: String)
    case multi
}

extension Target {
    static func makeFinder(_ name: String, type: PlaceType) -> [Target] {
        let targetName = name
        let bundleId = "com.dylanelliott.\(name)"
        
        var infoPlistExtensions: [String: InfoPlist.Value] = [
            "NSLocationWhenInUseUsageDescription": "Location is required to show you to your destinations",
            "UISupportedInterfaceOrientations": .array(["UIInterfaceOrientationPortrait"]),
            "CFBundleShortVersionString": .string(version),
            "CFBundleVersion": .string("\(buildNumber)")
        ]
        
        if case let .single(identifier) = type {
            infoPlistExtensions["WFPlacesType"] = .string(identifier)
        }

        let appTarget: Target = Target(name: targetName,
            platform: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTarget: .iOS(targetVersion: "12.0", devices: [.iphone]),
            infoPlist: .extendingDefault(with: infoPlistExtensions),
            sources: [
                    "\(name)/Sources/**",
                    "Wayfinder Shared/Sources/**"
            ],
            resources: [
                "\(name)/Resources/**",
                "Wayfinder Shared/Resources/**"
            ],
            dependencies: [
                .framework(path: "Carthage/Build/iOS/Alamofire.framework")
            ],
            settings: Settings(
                base: [
                    "DEVELOPMENT_TEAM": "6CW3378X23",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS" : (type == .multi ? "MULTIPLACE" : "")
                ],
                debug: Configuration(settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "$(inherited) DEBUG",
                    "CODE_SIGN_STYLE": "Automatic"
                ]),
                release: Configuration(settings: [
                    "CODE_SIGN_IDENTITY": "iPhone Distribution: Dylan Elliott (6CW3378X23)",
                    "PROVISIONING_PROFILE_SPECIFIER": "com.dylanelliott.\(targetName) AppStore"
                ])
            )
        )

        let testTarget: Target = Target(
            name: "\(name)_UITests",
            platform: .iOS,
            product: .uiTests,
            bundleId: "\(bundleId).uiTests",
            infoPlist: .extendingDefault(with: [:]),
            sources: [
                "Wayfinder Shared/Tests/**",
                "fastlane/SnapshotHelper.swift"
            ],
            dependencies: [
                .target(name: targetName)
            ],
            settings: Settings(
                base: ["DEVELOPMENT_TEAM": "6CW3378X23"]
            )
        )
        
        return [appTarget, testTarget]

    }
}


let project = Project(
	name: "Wayfinder",
	targets: [
        Target.makeFinder("Wayfinder", type: .multi),
        Target.makeFinder("Beerfinder", type: .single("liquor_store")),
        Target.makeFinder("SupermarketFinder", type: .single("supermarket")),
        Target.makeFinder("GroceryFinder", type: .single("test"))
	].flatMap { $0 }
)
