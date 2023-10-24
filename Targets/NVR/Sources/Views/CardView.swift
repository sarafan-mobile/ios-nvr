//
//  CardView.swift
//  Swipeable Cards
//
//  Created by Oleg Frolov on 27.06.2021.
//
// My original concept https://dribbble.com/shots/2313705-Ambivalence-ll-Monday

import SwiftUI

enum QuestionState {
    case yes, no, skip, empty
    
    var iconName: String {
        switch self {
        case .yes: return "StateYes"
        case .no: return "StateNo"
        case .empty: return "StateEmpty"
        case .skip: return ""
        }
    }
    
    var color: Color {
        switch self {
        case .yes: return .green
        case .no: return .red
        case .empty, .skip: return .clear
        }
    }
}

struct CardView: View {
    var text: String
    var offset: Int = 0
    var action: (QuestionState) -> Void
    
    @State private var translation: CGFloat = 0
    @State private var motionOffset: Double = 0.0
    @State private var motionScale: Double = 0.0
    @State private var state: QuestionState = .empty
    
    private let triggerZone: Double = 0.5
    private func setCardState(offset: CGFloat) -> QuestionState {
        if offset <= -triggerZone { return .no }
        if offset >= triggerZone { return .yes }
        return .empty
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text(text)
                    .font(.montserrat(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                    .padding(16)
                VStack {
                    Spacer()
                    Button(action: { action(.skip) }) {
                        HStack(spacing: 10) {
                            Text("NEXT")
                                .font(.montserrat(size: 15, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.montserrat(size: 20, weight: .semibold))
                        }
                        .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                        .frame(width: 0.65 * geometry.size.width, height: 55)
                        .background(
                            Capsule()
                                .stroke(NVRAsset.Assets.dark.swiftUIColor, lineWidth: 1)
                        )
                    }
                }
                .padding(.bottom, 24)
            
            }
                .frame(width: geometry.size.width, height: geometry.size.width)
                .background(
                    ZStack {
                        Rectangle().fill(state.color)
                        calcGradient().opacity(1 - motionScale * 0.5)
                    }
                )
                .cornerRadius(24)
                .rotationEffect(
                    .degrees(Double(translation / geometry.size.width * CardViewConsts.cardRotLimit)),
                    anchor: .bottom
                )
                .offset(x: translation, y: translation * 0.5)
                .animation(
                    .interactiveSpring(
                        response: CardViewConsts.springResponse,
                        blendDuration: CardViewConsts.springBlendDur
                    )
                )
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            guard offset == 0 else { return }
                            let translationWidth = gesture.translation.width
                            translation = translationWidth
                            motionOffset = Double(translationWidth / geometry.size.width)
                            motionScale = Double.remap(
                                from: motionOffset,
                                fromMin: CardViewConsts.motionRemapFromMin,
                                fromMax: CardViewConsts.motionRemapFromMax,
                                toMin: CardViewConsts.motionRemapToMin,
                                toMax: CardViewConsts.motionRemapToMax
                            )
                            state = setCardState(offset: translationWidth)
                        }
                        .onEnded { gesture in
                            guard offset == 0 else { return }
                            let offset = Double(gesture.translation.width / geometry.size.width)
                            translation = .zero
                            motionScale = 0.0
                            if abs(offset) > 0.3 { action(state) }
                            state = .empty
                        }
                )
        }
    }
    
    func calcGradient() -> LinearGradient {
        typealias Coefficients = (a: Double, b: Double, c: Double)
        let redArgs: Coefficients = (-0.02, 0.02, 1.0)
        let greenArgs: Coefficients = (-0.15, 0.22, 0.82)
        let blueArgs: Coefficients = (-0.06, 0.05, 0.98)
        let x = Double(offset)
        let solve: (Coefficients) -> Double = {
            max(0, min(1, $0.a * x * x + $0.b * x + $0.c))
        }
        let color = Color(red: solve(redArgs), green: solve(greenArgs), blue: solve(blueArgs))
        let stops: [Gradient.Stop]
        if offset == 0 {
            stops = [
                Gradient.Stop(color: color, location: 0),
                Gradient.Stop(color: NVRAsset.Assets.gradientLightEnd.swiftUIColor, location: 1),
            ]
        } else {
            stops = [
                Gradient.Stop(color: NVRAsset.Assets.gradientLightEnd.swiftUIColor, location: 0),
                Gradient.Stop(color: color, location: 1),
            ]
        }
        return LinearGradient(
            stops: stops,
            startPoint: UnitPoint(x: 0, y: 0.0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
}

private struct CardViewConsts {
    static let cardRotLimit: CGFloat = 20.0
    
    static let motionRemapFromMin: Double = 0.0
    static let motionRemapFromMax: Double = 0.25
    static let motionRemapToMin: Double = 0.0
    static let motionRemapToMax: Double = 1.0
    
    static let springResponse: Double = 0.5
    static let springBlendDur: Double = 0.3
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CardView(text: "Hello world, Hello world, Hello world", action: { _ in })
                .padding()
                .offset(y: 192)
        }
        .background(NVRAsset.Assets.dark.swiftUIColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct DeckCardView: View {
    var text: String
    var offset: CGFloat
    
    @State private var translation: CGSize = .zero
    @State private var motionOffset: Double = 0.0
    @State private var motionScale: Double = 0.0
    // @State private var lastCardState: DayState = .empty
    
    var body: some View {
        Text(text)
            .font(.montserrat(size: 34, weight: .bold))
            .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
            .padding(.horizontal, 59)
            .frame(
                width: 335 - offset * 16,
                height: 335 - offset * 16
            )
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .white, location: 0),
                        Gradient.Stop(color: Color(red: 0.88, green: 0.82, blue: 1), location: 1),
                    ],
                    startPoint: UnitPoint(x: 0.61, y: 1),
                    endPoint: UnitPoint(x: 0.03, y: 0)
                )
            )
            .cornerRadius(24)
            .opacity(1 - offset * 0.1)
            .rotationEffect(.degrees(0))
            .offset(x: 0, y: offset * 16)
    }
}
