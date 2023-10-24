//
//  PaywallLegalButtons.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 10.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct PaywallLegalButtons: View {
    var body: some View {
        HStack(spacing: 0) {
            Link(
                SettingsItem.privacyPolicy.title,
                destination: Constants.privacyPolicy
            ).padding(8)
            Link(
                SettingsItem.termsOfUse.title,
                destination: Constants.termsOfUse
            ).padding(8)
        }
        .font(Font.montserrat(size: 14, weight: .medium))
    }
}

struct PaywallLegalButtons_Previews: PreviewProvider {
    static var previews: some View {
        PaywallLegalButtons()
    }
}
