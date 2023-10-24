//
//  SpecialOfferScreen.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 10.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct SpecialOfferScreen: View {
    @EnvironmentObject var purchase: PurchaseManager
    @EnvironmentObject var notifications: NotificationManager
    @State var isPurchasing: Bool = false
    var dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("-50%")
                .font(.montserrat(size: 82, weight: .bold))
                .foregroundColor(NVRAsset.Assets.rose.swiftUIColor)
                .padding(.top, 35)
            
            Text("PAYWALL_UNLOCK")
                .font(.montserrat(size: 17, weight: .bold))
                .foregroundColor(NVRAsset.Assets.rose.swiftUIColor)
                .padding(.top, 8)
            
            TagView(text: "PAYWALL_OFFER")
                .padding(.top, 10)
            
            if let info = purchase.promoInfo {
                Text(info)
                    .font(Font.montserrat(size: 15, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                    .padding(.vertical, 24)
                
                WideButton(
                    label: "CONTINUE",
                    foregroundColor: .white,
                    backgroundColor: .rose,
                    isLoading: $isPurchasing
                ) { makePurchase() }
            } else {
                ProgressView() {
                    Text("LOADING")
                        .font(Font.montserrat(size: 15, weight: .bold))
                }
                .tint(.white)
            }
            
            PaywallLegalButtons()
                .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                .opacity(0.5)
        }
        .padding(.horizontal, 16)
        .overlay {
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(Font.system(size: 17, weight: .semibold))
                            .foregroundColor(NVRAsset.Assets.dark.swiftUIColor.opacity(0.5))
                            .padding(16)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .analyticsScreen(name: "Special Offer")
    }
    
    func makePurchase() {
        isPurchasing = true
        purchase.purchasePromo { result in
            defer { isPurchasing = false }
            switch result {
            case .success(let isPurchased):
                if isPurchased { dismiss() }
            case .failure(let error):
                notifications.error(error)
            }
        }
    }
}

struct SpecialOfferScreen_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(
            isShowing: .constant(true),
            content: SpecialOfferScreen {}
        )
    }
}
