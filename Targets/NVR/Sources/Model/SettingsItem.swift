//
//  SettingsItem.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 08.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import Foundation
import SwiftUI
import MessageUI

enum SettingsItem: Hashable {
    /// General
    case premium, support, rate, restore, language, howToPlay
    /// Legal information
    case termsOfUse, privacyPolicy
    
    var title: LocalizedStringKey {
        switch self {
        case .premium: return "SETTINGS_TRY_PREMIUM"
        case .support: return "SETTINGS_SUPPORT"
        case .rate: return "SETTINGS_RATE"
        case .restore: return "SETTINGS_RESTORE"
        case .language: return "SETTINGS_LANGUAGE"
        case .howToPlay: return "SETTINGS_HOW_TO_PLAY"
            
        case .termsOfUse: return "SETTINGS_TERMS_OF_USE"
        case .privacyPolicy: return "SETTINGS_PRIVACY_POLICY"
        }
    }
    
    var icon: Image {
        switch self {
        case .premium: return Image(systemName: "bolt.fill")
        case .support: return NVRAsset.Assets.settingsSupport.swiftUIImage
        case .rate: return NVRAsset.Assets.settingsRate.swiftUIImage
        case .restore: return NVRAsset.Assets.settingsRestore.swiftUIImage
        case .language: return NVRAsset.Assets.settingsLocale.swiftUIImage
        case .howToPlay: return NVRAsset.Assets.settingsHowToPlay.swiftUIImage
        case .termsOfUse: return NVRAsset.Assets.settingsLegal.swiftUIImage
        case .privacyPolicy: return NVRAsset.Assets.settingsLegal.swiftUIImage
        }
    }
    
    var link: URL? {
        switch self {
        case .termsOfUse:
            return Constants.termsOfUse
        case .privacyPolicy:
            return Constants.privacyPolicy
        case .support:
            if MFMailComposeViewController.canSendMail() { return nil }
            return SupportScreen.createEmailUrl()
        case .language:
            return URL(string: UIApplication.openSettingsURLString)
        case .howToPlay:
            return nil
        default:
            return nil
        }
    }
}
