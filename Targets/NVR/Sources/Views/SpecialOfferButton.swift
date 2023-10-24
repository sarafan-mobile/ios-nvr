//
//  SpecialOfferButton.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 10.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct SpecialOfferButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 7) {
                NVRAsset.Assets.crown.swiftUIImage
                    .frame(width: 24, height: 24)
                    .foregroundColor(NVRAsset.Assets.rose.swiftUIColor)
                Text("PAYWALL_UNLOCK")
                    .font(.montserrat(size: 15, weight: .bold))
                    .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                TagView(text: "PAYWALL_OFFER")
            }
        }
        .buttonStyle(SpecialOfferButtonStyle())
    }
}

struct SpecialOfferButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.4 : 1)
            .padding(.top, 16)
            .padding(.bottom, 25)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Rectangle().fill(LinearGradient.light)
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom) {
                            NVRAsset.Assets.specialOfferCardsLeft.swiftUIImage
                            Spacer()
                            NVRAsset.Assets.specialOfferCardsRight.swiftUIImage
                        }
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.16), radius: 3.5, x: 0, y: 4)
    }
}

struct SpecialOfferButton_Previews: PreviewProvider {
    static var previews: some View {
        SpecialOfferButton {}
            .previewLayout(.sizeThatFits)
    }
}
