//
//  PacksScreen.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 04.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct PacksScreen: View {
    @EnvironmentObject var purchase: PurchaseManager
    @EnvironmentObject var questions: PacksManager
    @AppStorage("isFirstRun") private var isFirstRun: Bool = true
    
    @State private var selectedPacks: [QuestionPack] = []
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var showingSpecialOffer = false
    @State private var isGameActive = false
    @State private var shouldDisplayPromo = true
    
    private var selectedQuestions: Int { selectedPacks.reduce(0, { $0 + $1.amount }) }
    
    let numberOfColumns: Int = 2
    var catalog: some View {
        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
            let amount = questions.availablePacks.count
            let rows = stride(from: 0, to: amount, by: numberOfColumns)
                .map { offset in
                    (0..<numberOfColumns)
                        .map { offset + $0 }
                        .filter { $0 < amount }
                }
            ForEach(Array(rows.enumerated()), id: \.offset) { offset, row in
                if offset == 2, purchase.promoInfo != nil, !purchase.isPurchased {
                    SpecialOfferButton { showingSpecialOffer.toggle() }
                        .transition(.opacity)
                }
                GridRow {
                    let items = row.map { questions.availablePacks[$0] }
                    ForEach(items) { pack in
                        QuestionPackCell(
                            pack: pack,
                            isSelected: selectedPacks.contains(pack),
                            isPremium: !purchase.isPurchased && pack.isPremium,
                            onSelect: { triggerPack(pack: pack, isOpen: false) },
                            onOpen: { triggerPack(pack: pack, isOpen: true) }
                        )
                    }
                }
            }
        }.frame(maxWidth: .infinity)
    }
    
    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                Text("PACKS_TITLE")
                    .font(.montserrat(size: 17, weight: .semibold))
                Text("PACKS_SELECT")
                    .font(.montserrat(size: 34, weight: .semibold))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                catalog
            }
            .padding(.horizontal, 20)
            .padding(.bottom, (selectedPacks.isEmpty ? 0 : PacksSelectionView.height) + 20)
        }
        .overlay {
            if !selectedPacks.isEmpty {
                VStack {
                    Spacer()
                    PacksSelectionView(
                        packs: $selectedPacks,
                        isGameActive: $isGameActive
                    )
                }
                .transition(.move(edge: .bottom))
                .animation(.default)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            content
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { showingSettings.toggle() }) {
                            Image("settings")
                                .foregroundColor(.white)
                        }
                        
                    }
                    if !purchase.isPurchased {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ProButton { showingPaywall.toggle() }
                        }
                    }
                }
                .onAppear { selectedPacks.removeAll() }
                .foregroundColor(.white)
                .background(Gradient.rose)
                .background(
                    NavigationLink(
                        destination: GameScreen(packs: selectedPacks),
                        isActive: $isGameActive,
                        label: { EmptyView() }
                    )
                )
        }
        .fullScreenCover(isPresented: $showingSettings) { SettingsScreen() }
        .fullScreenCover(isPresented: $showingPaywall) { PaywallScreen() }
        .overlay { BottomSheet(
            isShowing: $showingSpecialOffer,
            content: SpecialOfferScreen { showingSpecialOffer = false }
        )}
        .onAppear { showPromoIfNeeded() }
        .analyticsScreen(name: "Packs")
    }
    
    func triggerPack(pack: QuestionPack, isOpen: Bool) {
        if selectedPacks.contains(pack) {
            selectedPacks.remove(pack)
        } else if pack.isPremium && !purchase.isPurchased {
            showingPaywall = true
        } else {
            selectedPacks.append(pack)
            guard selectedPacks.count == 1, isOpen else { return }
            isGameActive = true
        }
    }
    
    func showPromoIfNeeded() {
        if isFirstRun {
            shouldDisplayPromo = false
            isFirstRun = false
            return
        }
        guard !isFirstRun, shouldDisplayPromo, !purchase.isPurchased else { return }
        shouldDisplayPromo = false
        showingSpecialOffer = true
        isFirstRun = false
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension Array where Element == QuestionPack {
    func contains(_ pack: QuestionPack) -> Bool {
        first(where: { $0.id == pack.id }) != nil
    }
    
    mutating func remove(_ pack: QuestionPack) {
        self = filter { $0.id != pack.id }
    }
}

struct PacksList_Previews: PreviewProvider {
    static var previews: some View {
        PacksScreen()
            .environmentObject(PreviewManagers.purchase)
            .environmentObject(PreviewManagers.questions)
    }
}

struct PreviewManagers {
    static let purchase = PurchaseManager()
    static let questions = PacksManager()
    static let notifications = NotificationManager()
}
