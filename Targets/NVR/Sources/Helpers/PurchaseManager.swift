//
//  PurchaseManager.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 09.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI
import NVRKit
import ApphudSDK
import Combine
import StoreKit

class PurchaseManager: ObservableObject {
    @Published var isPurchased: Bool = false
    @Published var paywall: ApphudPaywall?
    
    @Published var product: ApphudProduct?
    @Published var productInfo: String?
    
    @Published var promoProduct: ApphudProduct?
    @Published var promoInfo: String?
    
    var trialPeriod: String?
    var subscriptionPrice: String?
    var subscriptionPeriod: String?
    
    private var cancellables: Set<AnyCancellable> = []
    private let manager: IAPManager
    
    private let periodFormatter = PeriodFormatter()
    private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    init() {
        manager = .init(apiKey: Constants.apphudKey)
        bindManager()
    }
    
    func bindManager() {
        manager.$isPurchased
            .assign(to: \.isPurchased, on: self)
            .store(in: &cancellables)
        manager.$defaultPaywall
            .sink { [weak self] paywall in
                guard let self else { return }
                self.paywall = paywall
                self.updateProduct(paywall?.products.first)
            }
            .store(in: &cancellables)
        manager.$paywalls
            .sink { [weak self] paywalls in
                self?.updatePromoProduct(paywalls["promo"]?.products.first)
            }
            .store(in: &cancellables)
    }
    
    func purchase(_ handler: @escaping (Result<Bool, Error>) -> Void) {
        if let product {
            manager.purchase(product, handler: handler)
        } else {
            handler(.failure(NVRError.productNotFound))
        }
    }
    
    func purchasePromo(_ handler: @escaping (Result<Bool, Error>) -> Void) {
        if let promoProduct {
            manager.purchase(promoProduct, handler: handler)
        } else {
            handler(.failure(NVRError.productNotFound))
        }
    }
    
    func restore(_ handler: @escaping (Result<Bool, Error>) -> Void) {
        manager.restore(completion: handler)
    }
                 
    func updateProduct(_ product: ApphudProduct?) {
        guard
            let product,
            let skProduct = product.skProduct
        else {
            self.product = nil
            subscriptionPrice = nil
            trialPeriod = nil
            subscriptionPeriod = nil
            return
        }
        self.product = product
        priceFormatter.locale = skProduct.priceLocale
        subscriptionPrice = priceFormatter.string(from: skProduct.price)
        
        if let discount = skProduct.introductoryPrice, discount.paymentMode == .freeTrial {
            trialPeriod = periodFormatter.format(period: discount.subscriptionPeriod)
        } else {
            trialPeriod = nil
        }
        
        if let period = skProduct.subscriptionPeriod {
            subscriptionPeriod = periodFormatter.formatSubscriptionPeriod(period)
        } else {
            subscriptionPeriod = nil
        }
        
        formatProductInfo()
    }
    
    func formatProductInfo() {
        var result = ""
        if let trialPeriod {
            result += NVRStrings.paywallTrialTemplate(trialPeriod)
        }
        if let subscriptionPrice, let subscriptionPeriod {
            result +=  NVRStrings.paywallSubscriptionTemplate(subscriptionPrice, subscriptionPeriod)
            result += "\n" + NVRStrings.paywallCancelAnyTime
        }
        productInfo = result.isEmpty ? nil : result
    }
    
    func updatePromoProduct(_ product: ApphudProduct?) {
        promoProduct = product
        guard let product, let skProduct = product.skProduct else {
            promoInfo = nil
            return
        }
        priceFormatter.locale = skProduct.priceLocale
        guard let price = priceFormatter.string(from: skProduct.price) else {
            promoInfo = nil
            return
        }
        var info = NVRStrings.paywallLifetimeTameplate(price)
        if skProduct.subscriptionPeriod == nil {
            info += " " + NVRStrings.paywallLifetimePurchase
        }
        promoInfo = info
    }
}

class PeriodFormatter: DateComponentsFormatter {
    override init() {
        super.init()
        maximumUnitCount = 1
        unitsStyle = .full
        zeroFormattingBehavior = .dropAll
        collapsesLargestUnit = false
        allowedUnits = [.month]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func format(period: SKProductSubscriptionPeriod) -> String? {
        let unit: NSCalendar.Unit
        switch period.unit {
        case .day: unit = .day
        case .week: unit = .weekOfMonth
        case .month: unit = .month
        case .year: unit = .year
        @unknown default: return nil
        }
        return format(unit: unit, numberOfUnits: period.numberOfUnits)
    }
    
    func formatSubscriptionPeriod(_ period: SKProductSubscriptionPeriod) -> String? {
        let numberOfUnits = period.numberOfUnits
        guard numberOfUnits > 1 else { return format(period: period) }
        var dayUnits = 0
        switch period.unit {
        case .day: dayUnits = numberOfUnits
        case .week: dayUnits = 7 * numberOfUnits
        case .month:
            if numberOfUnits == 12 {
                return format(unit: .year, numberOfUnits: 1)
            } else {
                return format(period: period)
            }
        case .year:
            return format(period: period)
        @unknown default:
            return format(period: period)
        }
        switch dayUnits {
        case 7: return format(unit: .weekOfMonth, numberOfUnits: 1)
        case 30, 31: return format(unit: .month, numberOfUnits: 1)
        case 365: return format(unit: .year, numberOfUnits: 1)
        default: return format(period: period)
        }
    }
    
    func format(unit: NSCalendar.Unit, numberOfUnits: Int) -> String? {
        allowedUnits = [unit]
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        switch unit {
        case .day: dateComponents.setValue(numberOfUnits, for: .day)
        case .weekOfMonth: dateComponents.setValue(numberOfUnits, for: .weekOfMonth)
        case .month: dateComponents.setValue(numberOfUnits, for: .month)
        case .year: dateComponents.setValue(numberOfUnits, for: .year)
        default: return nil
        }
        return string(from: dateComponents)
    }
}
