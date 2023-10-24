//
//  OnboardingViewController.swift
//  QRCat
//
//  Created by Igor Efremov on 23.07.2023.
//  Copyright © 2023 Sarafan Mobile Limited. All rights reserved.
//

import UIKit
import StorySDK

extension UIView {
    func addMultipleSubviews(with subviews: [UIView?]) {
        subviews.compactMap {$0}.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    func addTapTouch(_ target: AnyObject, action: Selector) {
        isUserInteractionEnabled = true

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
}

final class OnboardingViewController: UIViewController {
    weak var coordinator: AppCoordinatorProtocol?
    weak var model: SettingsModel?
    weak var storiesModel: StoriesPlayerModel?
    
    private let widget = SRStoryWidget()

    init(model: SettingsModel, storiesModel: StoriesPlayerModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        self.model?.delegate = self
        self.storiesModel = storiesModel
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widget.isHidden = true
        
        setupLayout()
        widget.delegate = self
        
        storiesModel?.setup(widget: widget, onboardingFilter: false)
        storiesModel?.reloadApp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGradientBackground(top: NVRAsset.Assets.gradientStart.color,
                              bottom: NVRAsset.Assets.gradientEnd.color)
    }
    
    private func setupLayout() {
        view.addMultipleSubviews(with: [widget])
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            widget.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            widget.topAnchor.constraint(equalTo: safeArea.topAnchor),
            widget.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    private func setGradientBackground(top: UIColor, bottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [bottom.cgColor, top.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension OnboardingViewController: SettingsModelDelegate {
    func didChange() {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("hideOnboarding"),
                                            object: self, userInfo: nil)
        }
    }
}

extension OnboardingViewController: SRStoryWidgetDelegate {
    func onWidgetErrorReceived(_ error: Error, widget: SRStoryWidget) {
        print(error)
    }
    
    func onWidgetGroupPresent(index: Int, groups: [SRStoryGroup], widget: SRStoryWidget) {
        guard groups.count > index else { return }
        guard let storiesModel = storiesModel else { return }
        
        let group = groups[index]
        var onboardingGroup = group
        
        if storiesModel.groupToOpen == Constants.onboardingGroup {
            onboardingGroup.settings?.isProgressHidden = true
            onboardingGroup.settings?.isProhibitToClose = true
        }
        
        coordinator?.openStories(group: onboardingGroup, in: self,
                                 delegate: self, animated: false)
    }
    
    func onWidgetGroupsLoaded(groups: [SRStoryGroup]) {
        guard let storiesModel = storiesModel else { return }
        storiesModel.openAsOnboarding(groupId: storiesModel.groupToOpen)
    }
    
    func onWidgetGroupClose() {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("hideOnboarding"),
                                            object: self, userInfo: nil)
        }
    }
    
    func onWidgetMethodCall(_ selectorName: String?) {
        guard let selectorName = selectorName else { return }
        
        let sel = NSSelectorFromString(selectorName)
        if canPerformAction(sel, withSender: self) {
            performSelector(onMainThread: sel, with: nil, waitUntilDone: true)
        }
    }
}
