//
//  PaywallScreen.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 09.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct PaywallScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var purchase: PurchaseManager
    @EnvironmentObject var notifications: NotificationManager
    @State private var canBeClosed: Bool = false
    @State private var isPurchasing: Bool = false
    /// Time when closing the screen is unabled
    var cooldownInterval: TimeInterval = 3
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                ZStack(alignment: .center) {
                    VStack(spacing: 32) {
                        PaywallLogoView()
                        PaywallFeaturesView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                if let info = purchase.productInfo {
                    VStack(spacing: 15) {
                        Text(info)
                            .font(Font.montserrat(size: 15, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 9)
                        WideButton(
                            label: "CONTINUE",
                            foregroundColor: NVRAsset.Assets.dark.swiftUIColor,
                            backgroundColor: .light,
                            isLoading: $isPurchasing
                        ) { makePurchase() }
                    }
                } else {
                    ProgressView() {
                        Text("LOADING")
                            .font(Font.montserrat(size: 15, weight: .bold))
                    }
                    .tint(.white)
                }
                PaywallLegalButtons()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Gradient.rose)
            .toolbar {
                if canBeClosed {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CloseButton { dismiss() }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 10) {
                        Text("NVR")
                            .font(Font.montserrat(size: 17, weight: .bold))
                            .foregroundColor(.white)
                        ProButtonContent().fixedSize()
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + cooldownInterval) {
                canBeClosed = true
            }
        }
        .overlay { NotificationView() }
        .analyticsScreen(name: "Paywall")
    }
    
    func makePurchase() {
        isPurchasing = true
        purchase.purchase { result in
            defer { isPurchasing = false }
            switch result {
            case .success(let result):
                if result { dismiss() }
            case .failure(let error):
                notifications.error(error)
            }
        }
    }
}

struct PaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaywallScreen()
            .environmentObject(PreviewManagers.purchase)
            .environmentObject(PreviewManagers.notifications)
    }
}
