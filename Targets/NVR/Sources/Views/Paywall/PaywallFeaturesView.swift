//
//  PaywallFeaturesView.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 10.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct PaywallFeaturesView: View {
    var features: [(icon: NVRImages, text: LocalizedStringKey)] = [
        (NVRAsset.Assets.paywallQuestions, "All spicy questions"),
        (NVRAsset.Assets.paywallUpdates, "Weekly updates"),
        (NVRAsset.Assets.paywallAds, "Ads free 100%"),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(features.enumerated()), id: \.offset) { _, feature in
                HStack(spacing: 8) {
                    feature.icon.swiftUIImage
                    Text(feature.text)
                }
            }
        }
        .foregroundColor(.white)
        .font(Font.montserrat(size: 15, weight: .bold))
    }
}

struct PaywallFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallFeaturesView()
            .background(Gradient.rose)
    }
}
