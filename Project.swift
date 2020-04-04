import ProjectDescription

extension Target {
    static func makeFinder(_ name: String) -> Target {
        let targetName = name
        let bundleId = "com.dylanelliott.\(name)"

        return Target(name: targetName,
            platform: .iOS,
            product: .app,
            bundleId: bundleId,
            infoPlist: .extendingDefault(with: [:]),
            sources: [
                    "\(name)/Sources/**",
                    "Wayfinder Shared/**"
            ],
            resources: ["\(name)/Resources/**"]
        )

    }
}


let project = Project(
	name: "Wayfinder",
	targets: [
        .makeFinder("Wayfinder"),
		.makeFinder("Beerfinder")
	]
)
