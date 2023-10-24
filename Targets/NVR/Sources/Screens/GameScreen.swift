//
//  GameScreen.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 04.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct GameScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.displayScale) var displayScale: CGFloat
    
    @EnvironmentObject var purchase: PurchaseManager
    @EnvironmentObject var packManager: PacksManager
    @EnvironmentObject var notifications: NotificationManager
    
    let packs: [QuestionPack]
    @State var questions: [GameQuestion]
    let visibleCards = 2
    
    private let questionsTotal: Int
    private let cardOffset: CGFloat = 24
    private let cardOffsetMultiplier: CGFloat = 4
    private let cardAlphaStep: Double = 0.1
    private var yCardsOffset: CGFloat { -CGFloat(visibleCards) * cardOffset / 2 }
    @State private var showingPaywall = false
    @State private var currentIndex: Int = 1
    @State private var renderedImage: Image?
    @StateObject var synthesizer = SpeechSynthesizer()
    
    private var isFavorite: Bool {
        guard let id = questions.last?.id else { return false }
        return packManager.isFavorite(id)
    }
    
    init(packs: [QuestionPack]) {
        let questions = PacksManager.makeQuestions(packs)
        self.packs = packs
        _questions = .init(initialValue: questions)
        self.questionsTotal = questions.count
        if let question = questions.last {
            _renderedImage = .init(initialValue: Self.makeCardPreview(question: question, scale: 2))
        } else {
            _renderedImage = .init(initialValue: nil)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                PacksTitleView(packs: packs, amount: questionsTotal, current: _currentIndex)
                Spacer()
            }
            if !questions.isEmpty {
                Spacer()
                HStack {
                    Text("PACKS_TITLE")
                        .font(.montserrat(size: 34, weight: .bold))
                    Spacer()
                }
                
                GeometryReader { geometry in
                    ZStack {
                        ForEach(Array(questions.enumerated()), id: \.offset) { offset, card in
                            CardView(
                                text: card.text,
                                offset: calcOffset(offset),
                                action: { state in
                                    guard state != .empty else { return }
                                    next()
                                }
                            )
                            .scaleEffect(offsetScale(offset: offset))
                            .offset(x: 0, y: calculateCardYOffset(geo: geometry, offset: offset))
                        }
                    }
                }
                HStack(spacing: 24) {
                    Spacer()
                    GameActionButton(image: NVRAsset.Assets.heart.swiftUIImage, isHighlighted: isFavorite) { like() }
                    GameActionButton(
                        image: synthesizer.isSpeaking ? NVRAsset.Assets.personCross.swiftUIImage : NVRAsset.Assets.personWave.swiftUIImage
                    ) { play() }
                    if let last = questions.last, let renderedImage {
                        ShareLink(
                            item: renderedImage,
                            message: Text(NVRStrings.shareTitle + "\n" + Constants.appstore.absoluteString),
                            preview: SharePreview(
                                last.fullText,
                                image: Image(last.packImageName)
                            )
                        ) {
                                NVRAsset.Assets.arrowshapeTurnUpRight.swiftUIImage
                                    .font(.montserrat(size: 24, weight: .semibold))
                                    .padding(15)
                            }
                            .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                            .background(Circle().fill(.white))
                            .frame(width: 55, height: 55)
                            .shadow(color: .black.opacity(0.16), radius: 3.5, x: 0, y: 4)
                        }
                    Spacer()
                }
                Spacer()
            } else {
                Spacer()
                ZStack(alignment: .center) {
                    VStack(alignment: .center, spacing: 10) {
                        NVRAsset.Assets.emptyView.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 84)
                        Text("GAME_EMPTY")
                            .font(.montserrat(size: 17, weight: .bold))
                    }
                    
                }
                .foregroundColor(.white)
                Spacer()
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("BACK")
                    }
                    .font(.montserrat(size: 15, weight: .bold))
                }
                .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                .padding(.horizontal, 25)
                .padding(.vertical, 16)
                .shadow(color: .black.opacity(0.16), radius: 3.5, x: 0, y: 4)
                .background(Capsule().fill(Gradient.light))
                .frame(alignment: .bottom)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Gradient.rose)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left").foregroundColor(.white)
                }
            }
            if !purchase.isPurchased {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ProButton { showingPaywall.toggle() }
                }
            }
        }
        .fullScreenCover(isPresented: $showingPaywall) { PaywallScreen() }
        .navigationBarBackButtonHidden(true)
        .analyticsScreen(
            name: "Game",
            extraParameters: ["number_of_packs": packs.count]
        )
    }
    
    private func like() {
        guard let question = questions.last else { return }
        packManager.toggleFavorite(question)
        guard packManager.isFavorite(question.id) else { return }
        notifications.show(title: NVRStrings.notificationAddedTitle,
                           info: NVRStrings.notificationAddedInfo)
    }
    
    private func play() {
        if synthesizer.isSpeaking {
            synthesizer.stop()
            return
        }
        guard let question = questions.last?.fullText else { return }
        synthesizer.speach(question)
    }
    
    private func next() {
        withAnimation(.easeInOut) {
            _ = questions.popLast()
            currentIndex = min(questionsTotal, questionsTotal - questions.count + 1)
            
            guard let last = questions.last else { return }
            guard let image = Self.makeCardPreview(question: last, scale: displayScale) else { return }
            renderedImage = image
        }
    }

    @MainActor static func makeCardPreview(question: GameQuestion, scale: CGFloat) -> Image? {
        let view = ShareCardView(imageName: question.packImageName, question: question.fullText)
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        guard let uiImage = renderer.uiImage else { return nil }
        return Image(uiImage: uiImage)
    }

    private func calculateCardYOffset(geo: GeometryProxy, offset: Int) -> CGFloat {
        let result = 0.05 * geo.size.width * CGFloat(calcOffset(offset))
        let scale = 1 - offsetScale(offset: offset)
        return result + geo.size.height * scale / 4
    }
    
    private func offsetScale(offset: Int) -> Double {
        1 - 0.10 * Double(calcOffset(offset))
    }
    
    private func calcOffset(_ offset: Int) -> Int {
        min(questions.count - (1 + offset), visibleCards)
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                GameScreen(packs: [
                    .init(
                        id: "test",
                        imageName: "",
                        name: "Test",
                        questions: [
                            Question(text: "traveled to another country", fullText: "Never have I ever traveled to another country"),
                            Question(text: "gone skydiving", fullText: "Never have I ever gone skydiving"),
                            Question(text: "eaten sushi", fullText: "Never have I ever eaten sushi"),
                        ]
                    )
                ])
            }.previewDisplayName("Cards")
            GameScreen(packs: []).previewDisplayName("Empty")
        }
        .environmentObject(PreviewManagers.purchase)
        .environmentObject(PreviewManagers.questions)
    }
}

struct GameActionButton: View {
    var image: Image
    var isHighlighted: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            image
                .font(.montserrat(size: 24, weight: .semibold))
                .padding(15)
                .foregroundColor(
                    isHighlighted ? .white : NVRAsset.Assets.dark.swiftUIColor
                )
                .background(
                    Circle().fill(
                        isHighlighted ? NVRAsset.Assets.rose.swiftUIColor : .white
                    )
                )
        }
        .frame(width: 55, height: 55)
        .shadow(color: .black.opacity(0.16), radius: 3.5, x: 0, y: 4)
    }
}
