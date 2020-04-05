import ProjectDescription

let version = "1.0"
let buildNumber = 1

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
                    "Single_Apps/\(name)/Sources/**",
                    "Single_Apps/Wayfinder Shared/Sources/**"
            ],
            resources: [
                "Single_Apps/\(name)/Resources/**",
                "Single_Apps/Wayfinder Shared/Resources/**"
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
                "Single_Apps/Wayfinder Shared/Tests/**",
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

    static func makeCreator() -> [Target] {
        let targetName = "FinderCreator"
        let bundleId = "com.dylanelliott.findercreator"
        
        var infoPlistExtensions: [String: InfoPlist.Value] = [
            "NSLocationWhenInUseUsageDescription": "Location is required to show you to your destinations",
            "UISupportedInterfaceOrientations": .array(["UIInterfaceOrientationPortrait"]),
            "CFBundleShortVersionString": .string(version),
            "CFBundleVersion": .string("\(buildNumber)"),
            "UIMainStoryboardFile": "CategoryList",
            "WFPlacesType": "supermarket",
            "NSAppTransportSecurity": .dictionary(["NSAllowsArbitraryLoads": .boolean(true)])
        ]

        let appTarget: Target = Target(name: targetName,
            platform: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTarget: .iOS(targetVersion: "12.1", devices: [.iphone]),
            infoPlist: .extendingDefault(with: infoPlistExtensions),
            sources: [
                    "Single_Apps/Wayfinder Shared/Sources/**",
                    "Single_Apps/FinderCreator/Sources/**"
            ],
            resources: [
                "Single_Apps/Wayfinder Shared/Resources/**",
                "Single_Apps/FinderCreator/Resources/**"
            ],
            dependencies: [
                .framework(path: "Carthage/Build/iOS/Alamofire.framework"),
                .framework(path: "Carthage/Build/iOS/SwiftyDraw.framework"),
                .framework(path: "Carthage/Build/iOS/ChromaColorPicker.framework"),
                .framework(path: "Carthage/Build/iOS/SnapKit.framework")
            ],
            settings: Settings(
                base: [
                    "DEVELOPMENT_TEAM": "6CW3378X23",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS" : "CREATOR"
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
        
        return [appTarget]

    }
}

let projectList = (try? String(contentsOfFile: "Single_Apps/PROJECTS")) ?? (try? String(contentsOfFile: "../Single_Apps/PROJECTS"))!

let singleTargets: [Target] = projectList.components(separatedBy: "\n").compactMap { project in
    let components = project.components(separatedBy: "~")
    guard components.count == 2 else { return nil }
    return (components[0], components[1])
}.flatMap { (components: (String, String)) -> [Target] in
    return Target.makeFinder(components.0 + "Finder", type: .single(components.1))
}

let project = Project(
	name: "Wayfinder",
	targets: [
        Target.makeFinder("Wayfinder", type: .multi),
        singleTargets,
        Target.makeCreator()
	].flatMap { $0 }
)
