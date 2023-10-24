//
//  SettingsScreen.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 08.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI
import StoreKit
import MessageUI
import FirebaseAnalyticsSwift

struct SettingsScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var purchase: PurchaseManager
    @EnvironmentObject var notifications: NotificationManager
    @State private var showingPaywall: Bool = false
    @State private var showHowToPlay: Bool = false
    @State private var showingSupport: Bool = false
    @State private var isRestoringPurchase: Bool = false
    @State private var supportState: Result<MFMailComposeResult, Error>?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if purchase.isPurchased {
                        SettingsSectionView(
                            items: [.support, .rate, .language, .howToPlay],
                            supportState: $supportState,
                            onTap: onTap
                        )
                    } else {
                        SettingsSectionView(
                            items: [.premium, .support, .rate, .restore, .language, .howToPlay],
                            isRestoringPurchase: $isRestoringPurchase,
                            supportState: $supportState,
                            onTap: onTap
                        )
                    }
                    HStack {
                        Text("SETTINGS_LEGAL")
                            .font(Font.montserrat(size: 17, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }.padding(.top, 14)
                    
                    SettingsSectionView(
                        items: [.privacyPolicy, .termsOfUse],
                        onTap: onTap
                    )
                }.padding(.horizontal, 16)
            }
            .background(Gradient.rose)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CloseButton { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("SETTINGS_TITLE")
                        .font(Font.montserrat(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(height: 25)
                }
            }
            .fullScreenCover(isPresented: $showingPaywall) { PaywallScreen() }
            .sheet(isPresented: $showingSupport) { SupportScreen(result: $supportState) }
            .fullScreenCover(isPresented: $showHowToPlay) { StoriesScreen(isOnboarding: false) }
        }
        .overlay { NotificationView() }
        .analyticsScreen(name: "Settings")
    }
    
    func onTap(_ item: SettingsItem) {
        switch item {
        case .premium:
            showingPaywall = true
        case .support:
            showingSupport = true
        case .rate:
            let scene = UIApplication.shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last?
                .windowScene
            if let scene {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                UIApplication.shared.open(Constants.rateApp)
            }
        case .restore:
            isRestoringPurchase = true
            purchase.restore { result in
                defer { isRestoringPurchase = false }
                switch result {
                case .success(let result):
                    if result {
                        notifications.show(
                            title: NVRStrings.notificationRestoredTitle,
                            info: NVRStrings.notificationRestoredInfo
                        )
                    } else {
                        notifications.show(
                            title: NVRStrings.settingsRestore,
                            info: NVRStrings.notificationNoSubscriptions
                        )
                    }
                case .failure(let error):
                    notifications.error(error)
                }
            }
        case .howToPlay:
            showHowToPlay = true
        case .termsOfUse, .privacyPolicy, .language:
            break
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .environmentObject(PreviewManagers.purchase)
    }
}

struct SettingsCell: View {
    let item: SettingsItem
    var info: String? = nil
    var onTap: (SettingsItem) -> Void
    @Binding var isLoading: Bool
    
    init(item: SettingsItem,
         isLoading: Binding<Bool> = .constant(false),
         info: String? = nil,
         onTap: @escaping (SettingsItem) -> Void) {
        self.item = item
        self.info = info
        self._isLoading = isLoading
        self.onTap = onTap
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.montserrat(size: 15, weight: .bold))
            if let info {
                Text(info)
                    .font(.montserrat(size: 14, weight: .medium))
            }
        }
    }
    
    var body: some View {
        if isLoading {
            SettingsButtonDecorator(icon: item.icon) {
                ProgressView().tint(.white)
            }
        } else {
            if let link = item.link {
                Link(destination: link) {
                    SettingsButtonDecorator(icon: item.icon) { title }
                }
            } else {
                Button(action: { onTap(item) } ) {
                    SettingsButtonDecorator(icon: item.icon) { title }
                }
            }
        }
    }
}

struct SettingsButtonDecorator<Content: View>: View {
    let icon: Image
    let content: Content
    
    init(icon: Image, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 10) {
            icon
                .frame(width: 24, height: 24)
            content
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .padding(.trailing, 6)
        }
        .foregroundColor(.white)
        .padding(16)
        .background(.clear)
    }
}

struct SettingsSectionView: View {
    let items: [SettingsItem]
    var onTap: (SettingsItem) -> Void
    @Binding var isRestoringPurchase: Bool
    @Binding var supportState: Result<MFMailComposeResult, Error>?
    
    init(items: [SettingsItem],
         isRestoringPurchase: Binding<Bool> = .constant(false),
         supportState: Binding<Result<MFMailComposeResult, Error>?> = .constant(nil),
         onTap: @escaping (SettingsItem) -> Void) {
        self.items = items
        self.onTap = onTap
        self._isRestoringPurchase = isRestoringPurchase
        self._supportState = supportState
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { offset, item in
                VStack(spacing: 0) {
                    if item == .restore {
                        SettingsCell(item: item,
                                     isLoading: $isRestoringPurchase,
                                     onTap: onTap)
                    } else if item == .support, let result = supportState {
                        let info: String? = {
                            switch result {
                            case .success(let success):
                                return success == .sent ? NVRStrings.notificationSupportSent : nil
                            case .failure(let error):
                                return error.localizedDescription
                            }
                        }()
                        SettingsCell(item: item, info: info, onTap: onTap)
                    } else {
                        SettingsCell(item: item, onTap: onTap)
                    }
                    if offset < items.count - 1 {
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 1)
                    }
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(.white.opacity(0.2)))
    }
}
