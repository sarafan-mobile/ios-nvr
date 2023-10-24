//
//  Analytics.swift
//  NVRKit
//
//  Created by Aleksei Cherepanov on 17.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import AppsFlyerLib

public final class Analytics {
    public static func addToFavorites(id: String, name: String) {
        FirebaseAnalytics.Analytics.logEvent(
            "add_to_favorites",
            parameters: ["card_id": id, "card_name": name]
        )
        AppsFlyerLib.shared().logEvent(
            "add_to_favorites",
            withValues: [
                "card_id": id,
                "card_name": name,
            ]
        )
    }
    
    public static func removeFromFavorites(id: String, name: String) {
        FirebaseAnalytics.Analytics.logEvent(
            "remove_from_favorites",
            parameters: ["card_id": id, "card_name": name]
        )
        AppsFlyerLib.shared().logEvent(
            "remove_from_favorites",
            withValues: [
                "card_id": id,
                "card_name": name,
            ]
        )
    }
    
    public static func startGame(packs: [String: String]) {
        FirebaseAnalytics.Analytics.logEvent(
            "remove_from_favorites",
            parameters: [
                "packs_ids": packs.map(\.key),
                "pakcs_names": packs.map(\.value),
            ]
        )
        AppsFlyerLib.shared().logEvent(
            "start_game",
            withValues: [
                "packs_ids": packs.map(\.key),
                "pakcs_names": packs.map(\.value),
            ]
        )
    }
}
