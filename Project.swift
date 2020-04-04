import ProjectDescription

enum PlaceType: Equatable {
    case single(_ identifier: String)
    case multi
}

extension Target {
    static func makeFinder(_ name: String, type: PlaceType) -> Target {
        let targetName = name
        let bundleId = "com.dylanelliott.\(name)"
        
        var infoPlistExtensions: [String: InfoPlist.Value] = [
            "NSLocationWhenInUseUsageDescription": "Location is required to show you to your destinations",
            "UISupportedInterfaceOrientations": .array(["UIInterfaceOrientationPortrait"])
        ]
        
        if case let .single(identifier) = type {
            infoPlistExtensions["WFPlacesType"] = .string(identifier)
        }

        return Target(name: targetName,
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
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS" : (type == .multi ? "MULTIPLACE" : "")
                ], 
                debug: Configuration(settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "$(inherited) DEBUG"
                ]),
                release: Configuration(settings: [
                    "DEVELOPMENT_TEAM": "6CW3378X23",
                    "CODE_SIGN_IDENTITY": "iPhone Distribution: Dylan Elliott (6CW3378X23)",
                    "PROVISIONING_PROFILE_SPECIFIER": "com.dylanelliott.\(targetName) AppStore"
                ])
            )
        )

    }
}


let project = Project(
	name: "Wayfinder",
	targets: [
        .makeFinder("Wayfinder", type: .multi),
        .makeFinder("Beerfinder", type: .single("liquor_store")),
        .makeFinder("SupermarketFinder", type: .single("supermarket"))
	]
)
