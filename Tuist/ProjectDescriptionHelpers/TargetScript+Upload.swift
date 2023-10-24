import ProjectDescription

extension TargetScript {
    public static func firebase(plist: Path) -> TargetScript {
        .post(
            path: .relativeToRoot("scripts/firebase.sh"),
            name: "Firebase Crashlystics",
            inputPaths: [plist]
        )
    }
}
