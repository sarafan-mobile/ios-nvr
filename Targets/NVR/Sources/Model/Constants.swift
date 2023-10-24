//
//  Constants.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 15.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import Foundation

struct Constants {
    static let appId = "itunes_app_id"
    static let supportEmail = "support_email"
    static let privacyPolicy = URL(string: "privacy_policy_url")!
    static let termsOfUse = URL(string: "terms_of_use_url")!
    static let appstore = URL(string: "https://apps.apple.com/app/id\(appId)")!
    static let rateApp = URL(string: "https://apps.apple.com/app/id\(appId)?action=write-review")!
    static let appsFlyerDevKey = ""
    static let apphudKey = ""
    
    static let storySdkAPIUrl = "https://api.storysdk.com/sdk/v1/"
    static let defaultAppAPIKey = ""
    static let onboardingGroup = ""
    static let howToPlayGroup = ""
}
