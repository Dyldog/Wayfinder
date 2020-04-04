import ProjectDescription

enum PlaceType: Equatable {
    case single(_ identifier: String)
    case multi
}

extension Target {
    static func makeFinder(_ name: String, type: PlaceType) -> Target {
        let targetName = name
        let bundleId = "com.dylanelliott.\(name)"
        
        var infoPlistExtensions = [String: InfoPlist.Value]()
        
        if case let .single(identifier) = type {
            infoPlistExtensions["WFPlacesType"] = .string(identifier)
        }

        return Target(name: targetName,
            platform: .iOS,
            product: .app,
            bundleId: bundleId,
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
                ])
        )
        )

    }
}


let project = Project(
	name: "Wayfinder",
	targets: [
        .makeFinder("Wayfinder", type: .multi),
        .makeFinder("Beerfinder", type: .single("liquor_store"))
	]
)
