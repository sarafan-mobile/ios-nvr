//
//  AppCoordinator.swift
//  NVR
//
//  Created by Igor Efremov on 15/08/2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import UIKit
import StorySDK

protocol SettingsModelDelegate: AnyObject {
    func didChange()
}

class SettingsModel {
    weak var delegate: SettingsModelDelegate?
    
    init() {}
}

protocol AppCoordinatorProtocol: AnyObject {
    var navigation: UINavigationController? { get set }
    var root: UIViewController? { get set }
    
    func openStories(group: SRStoryGroup, in vc: UIViewController,
                     delegate: SRStoryWidgetDelegate?, animated: Bool)
}

final class AppCoordinator: AppCoordinatorProtocol {
    var navigation: UINavigationController?
    var root: UIViewController?
    var model: SettingsModel
    
    init(model: SettingsModel) {
        self.model = model
    }
    
    func openStories(group: SRStoryGroup, in vc: UIViewController,
                     delegate: SRStoryWidgetDelegate?, animated: Bool) {
        let controller = SRStoriesViewController(group, asOnboarding: true)
        controller.delegate = delegate

        vc.present(controller, animated: animated)
    }
}
