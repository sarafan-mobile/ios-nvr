import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        platform: Platform,
        deploymentTarget: DeploymentTarget
    ) -> Project {
        let kitTarget = "\(name)Kit"
        var targets = makeAppTargets(
            name: name,
            platform: platform,
            deploymentTarget: deploymentTarget,
            dependencies: [
                .target(name: kitTarget),
                .external(name: "Lottie"),
                .external(name: "StorySDK"),
            ]
        )
        targets += makeFrameworkTargets(
            name: kitTarget,
            platform: platform,
            deploymentTarget: deploymentTarget,
            dependencies: [
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseAnalyticsSwift"),
                .external(name: "FirebaseRemoteConfig"),
                .external(name: "FirebaseCrashlytics"),
                .external(name: "FirebasePerformance"),
                .external(name: "FirebaseMessaging"),
                
                .external(name: "ApphudSDK"),
                .external(name: "AppsFlyerLib"),
//                .external(name: "ASAPTY_SDK"),
            ]
        )
        
        return Project(name: name,
                       organizationName: "Softeam OOO",
                       settings: .settings(base: ["DEVELOPMENT_TEAM": ""]),
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(
        name: String,
        platform: Platform,
        deploymentTarget: DeploymentTarget,
        dependencies: [TargetDependency]
    ) -> [Target] {
        let sources = Target(
            name: name,
            platform: platform,
            product: .framework,
            bundleId: "com.softeamapps.neverever.app.kit",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Targets/\(name)/Sources/**"],
            dependencies: dependencies,
            settings: .settings(base: [
                "OTHER_LDFLAGS": ["-ObjC"],
            ]),
            coreDataModels: [
//                CoreDataModel("Targets/\(name)/Resources/Model.xcdatamodeld"),
            ]
        )
        return [sources]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(
        name: String,
        platform: Platform,
        deploymentTarget: DeploymentTarget,
        dependencies: [TargetDependency]
    ) -> [Target] {
        let infoPlist: [String: InfoPlist.Value] = [
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationPortrait",
            ],
        ]
        
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "com.softeamapps.neverever.app",
            deploymentTarget: deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: [
                "Targets/\(name)/Sources/**",
                "PreviewContent/Sources/**",
            ],
            resources: [
                "Targets/\(name)/Resources/**",
                "Targets/\(name)/GoogleService-Info.plist",
                "PreviewContent/Resources/**",
            ],
            scripts: [
                .firebase(plist: .relativeToRoot("Targets/\(name)/GoogleService-Info.plist")),
            ],
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "DEVELOPMENT_ASSET_PATHS": ["PreviewContent/Sources", "PreviewContent/Resources"],
                ],
                configurations: [
                    .debug(name: .debug, xcconfig: .relativeToRoot("Configs/\(name).xcconfig")),
                    .release(name: .release, xcconfig: .relativeToRoot("Configs/\(name).xcconfig")),
                ],
                defaultSettings: .recommended(excluding: [])
            )
        )
        return [mainTarget]
    }
}
