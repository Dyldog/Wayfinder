import ProjectDescription

extension Target {
    static func makeFinder(_ name: String, multiplace: Bool) -> Target {
        let targetName = name
        let bundleId = "com.dylanelliott.\(name)"

        return Target(name: targetName,
            platform: .iOS,
            product: .app,
            bundleId: bundleId,
            infoPlist: .extendingDefault(with: [:]),
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
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS" : (multiplace ? "MULTIPLACE" : "")
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
        .makeFinder("Wayfinder", multiplace: true),
        .makeFinder("Beerfinder", multiplace: false)
	]
)
