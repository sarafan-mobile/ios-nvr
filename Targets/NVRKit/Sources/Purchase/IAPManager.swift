//
//  IAPManager.swift
//  NVRKit
//
//  Created by Aleksei Cherepanov on 11.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import Foundation
import ApphudSDK
import StoreKit

public class IAPManager: ApphudDelegate {
    let apiKey: String
    @Published public var defaultPaywall: ApphudPaywall?
    @Published public var paywalls: [String: ApphudPaywall] = [:]
    
    @Published var subscriptions: [ApphudSubscription] = []
    @Published var nonRenewingPurchases: [ApphudNonRenewingPurchase] = []
    @Published public var isPurchased: Bool = false
    @Published var hasLifetime: Bool = false
    @Published var hasActiveSubcription: Bool = false
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        start()
    }
    
    func start() {
        Apphud.setDelegate(self)
        Apphud.start(apiKey: apiKey)
        Apphud.migratePurchasesIfNeeded { _, _, _ in }
        updatePurchaseState()
    }
    
    func updatePurchaseState() {
        #if targetEnvironment(simulator)
        isPurchased = true
        #elseif DEBUG
        isPurchased = false
        #else
        isPurchased = Apphud.hasPremiumAccess()
        #endif
    }
    
    public func purchase(_ product: ApphudProduct, handler: @escaping (Result<Bool, Error>) -> Void) {
        Apphud.purchase(product) { result in
            if let error = result.error {
                if case SKError.paymentCancelled = error {
                    handler(.success(false))
                } else {
                    handler(.failure(error))
                }
            } else {
                handler(.success(result.subscription != nil))
            }
        }
    }
    
    public func restore(completion handler: @escaping (Result<Bool, Error>) -> Void) {
        Apphud.restorePurchases { subscriptions, purchases, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            if subscriptions?.first(where: { $0.isActive() }) != nil {
                handler(.success(true))
                return
            }
            if purchases?.first(where: { $0.isActive() }) != nil {
                handler(.success(true))
                return
            }
            handler(.success(false))
        }
    }
    
    // MARK: - ApphudDelegate
    
    @objc public func apphudSubscriptionsUpdated(_ subscriptions: [ApphudSubscription]) {
        self.subscriptions = subscriptions
        for subscription in subscriptions {
            guard subscription.isActive() else { continue }
            hasActiveSubcription = true
            break
        }
        updatePurchaseState()
    }
    
    @objc public func apphudNonRenewingPurchasesUpdated(_ purchases: [ApphudNonRenewingPurchase]) {
        self.nonRenewingPurchases = purchases
        for purchase in purchases {
            guard purchase.isActive() else { continue }
            hasLifetime = true
            break
        }
        updatePurchaseState()
    }
    
    @objc public func paywallsDidFullyLoad(paywalls: [ApphudPaywall]) {
        var dict: [String: ApphudPaywall] = [:]
        for paywall in paywalls {
            dict[paywall.identifier] = paywall
            if paywall.isDefault { defaultPaywall = paywall }
        }
        if defaultPaywall == nil { defaultPaywall = paywalls.first }
        self.paywalls = dict
    }
}
