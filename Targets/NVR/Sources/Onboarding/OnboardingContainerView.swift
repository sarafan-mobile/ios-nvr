//
//  OnboardingContainerView.swift
//  NVR
//
//  Created by Igor Efremov on 15/08/2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct OnboardingContainerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = OnboardingViewController
    
    var onboarding: Bool
    
    private let coordinator = AppCoordinator(model: SettingsModel())
    private let onboardingModel = StoriesPlayerModel(apiKey: Constants.defaultAppAPIKey,
                                                     groupToOpen: Constants.onboardingGroup)
    private let howToPlayModel = StoriesPlayerModel(apiKey: Constants.defaultAppAPIKey,
                                                    groupToOpen: Constants.howToPlayGroup)
    
    func makeUIViewController(context: Context) -> OnboardingViewController {
        let model = onboarding ? onboardingModel : howToPlayModel
        let vc = OnboardingViewController(model: coordinator.model, storiesModel: model)
        vc.coordinator = coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: OnboardingViewController, context: Context) {}
}
