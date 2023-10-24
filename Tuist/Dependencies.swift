import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
//        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "4.2.0")),
        .remote(url: "https://github.com/StorySDK/story-ios-sdk.git", requirement: .exact("0.9.1")),
        
        .remote(url: "https://github.com/apphud/ApphudSDK", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .exact("10.3.0")),
        .remote(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework", requirement: .upToNextMajor(from: "6.0.0")),
    ],
    platforms: [.iOS]
)
