//
//  StoriesPlayerModel.swift
//  NVR
//
//  Created by Igor Efremov on 15/08/2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import Foundation
import StorySDK

protocol StoriesPlayerModelDelegate: AnyObject {
    func apiKeyDidChanged()
}

class StoriesPlayerModel {
    var apiKey: String {
        didSet { delegate?.apiKeyDidChanged() }
    }
    private weak var widget: SRStoryWidget?
    weak var delegate: StoriesPlayerModelDelegate?
    
    var groupToOpen: String
    
    init(apiKey: String, groupToOpen: String, delegate: StoriesPlayerModelDelegate? = nil) {
        self.apiKey = apiKey
        self.groupToOpen = groupToOpen
        self.delegate = delegate
    }
    
    deinit {
        print("StoriesPlayerModel deinit")
    }
    
    func setup(widget: SRStoryWidget, onboardingFilter: Bool = true) {
        self.widget = widget
        
        let locale = Locale.preferredLanguages[0]
        let languageCode = Locale(identifier: locale).languageCode ?? "en"
        
        let configuration = SRConfiguration(language: languageCode,
                                            sdkId: apiKey,
                                            sdkAPIUrl: Constants.storySdkAPIUrl,
                                            needShowTitle: true,
                                            onboardingFilter: onboardingFilter)
        StorySDK.shared.configuration = configuration
    }
    
    func openAsOnboarding(groupId: String) {
        widget?.openAsOnboarding(groupId: groupId)
    }
    
    func fetchData() {
        widget?.load()
    }
    
    func openSettings() {
        widget?.load()
    }
    
    func reloadApp() {
        widget?.reload()
    }
}

