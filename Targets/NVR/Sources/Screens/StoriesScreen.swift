//
//  StoriesScreen.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 15.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import StorySDK
import StoreKit
import SwiftUI

struct StoriesRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SRStoriesViewController
    
    let group: SRStoryGroup
    let sdk: StorySDK
    let isOnboarding: Bool
    
    func makeUIViewController(context: Context) -> SRStoriesViewController {
        let vc = SRStoriesViewController(group, sdk: sdk, asOnboarding: isOnboarding)
        vc.view.backgroundColor = .clear
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SRStoriesViewController, context: Context) {}
}

struct StoriesScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var stories: StorySDKManager
    
    var isOnboarding: Bool
    
    var body: some View {
        StoryDecorator {
            if isOnboarding, let group = stories.onboarding {
                StoriesRepresentable(
                    group: group,
                    sdk: stories.sdk,
                    isOnboarding: true
                )
            } else if !isOnboarding, let group = stories.howToPlay {
                StoriesRepresentable(
                    group: group,
                    sdk: stories.sdk,
                    isOnboarding: false
                )
            }
        }
    }
}

private struct StoryDecorator<Content: View>: View {
    let content: Content
    
    @State private var alreadyShownRate = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient.rose)
            .onTapGesture {
                if !alreadyShownRate {
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
                    alreadyShownRate.toggle()
                }
            }
    }
}

extension StorySDK {
    static let onboarding: StorySDK = {
        let sdk = StorySDK(sdkId: Constants.defaultAppAPIKey)
        
        if let locale = Locale.preferredLanguages.first {
            let languageCode = Locale(identifier: locale).languageCode ?? "en"
            let configuration = SRConfiguration(language: languageCode,
                                                sdkId: Constants.defaultAppAPIKey)
            sdk.configuration = configuration
        }
        
        return sdk
    }()
}

final class StorySDKManager: ObservableObject {
    @Published private(set) var onboarding: SRStoryGroup?
    @Published private(set) var howToPlay: SRStoryGroup?
    
    @Published private(set) var error: Error?
    
    let sdk: StorySDK
    
    init() {
        sdk = .init(sdkId: Constants.defaultAppAPIKey)
        if let locale = Locale.preferredLanguages.first {
            let languageCode = Locale(identifier: locale).languageCode ?? "en"
            let configuration = SRConfiguration(language: languageCode,
                                                sdkId: Constants.defaultAppAPIKey)
            sdk.configuration = configuration
        }
        
        load()
    }
    
    func load() {
        sdk.getApp { [weak self] result in
            switch result {
            case .success(let _):
                self?.loadGroups()
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
    
    private func loadGroups() {
        sdk.getGroups { [weak self] result in
            switch result {
            case .success(let groups):
                for group in groups {
                    switch group.id {
                    case Constants.onboardingGroup:
                        self?.onboarding = group
                        self?.onboarding?.settings?.isProgressHidden = true
                        self?.onboarding?.settings?.isProhibitToClose = true
                    case Constants.howToPlayGroup:
                        self?.howToPlay = group
                    default:
                        break
                    }
                }
            case .failure(let error):
                self?.error = error
            }
        }
    }
}
