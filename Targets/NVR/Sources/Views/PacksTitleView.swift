//
//  PacksTitleView.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 04.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI

struct PacksTitleView: View {
    @State var current: Int
    let packs: [QuestionPack]
    var numberOfPacks: Int
    let amount: Int
    let rotationStep = 15
    
    
    init(packs: [QuestionPack], amount: Int, current: State<Int>) {
        self.numberOfPacks = packs.count
        self.amount = amount
        self.packs = Array(packs.prefix(3))
        self._current = current
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                ForEach(Array(packs.enumerated()), id: \.offset) { offset, pack in
                    RoundedRectangle(cornerRadius: 6)
                        .inset(by: 0.5)
                        .stroke(.white, lineWidth: 1)
                        .foregroundColor(.clear)
                        .frame(width: 24, height: 24)
                        .background(
                            Image(pack.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .background(NVRAsset.Assets.gray.swiftUIColor)
                                .cornerRadius(6)
                                .clipped()
                        )
                        .rotationEffect(.degrees(Double(offset * rotationStep)), anchor: UnitPoint(x: 0.5, y: 1))
                }
                .rotationEffect(.degrees(-Double((packs.count - 1) * rotationStep / 2)), anchor: UnitPoint(x: 0.5, y: 1))
            }
            
            if numberOfPacks == 0 {
                Text("GAME_TITLE_EMPTY")
            } else if numberOfPacks == 1 {
                Text(packs[0].name)
            } else {
                Text(NVRStrings.gameTitlePacks(numberOfPacks))
            }
            
            Text("(\(current)/\(amount))")
        }
        .font(.montserrat(size: 17, weight: .semibold))
        .foregroundColor(.white)
    }
}

struct PacksTitleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PacksTitleView(
                packs: [
                    QuestionPack(id: "1",
                                 imageName: "pack_1",
                                 name: "Start Pack",
                                 questions: []),
                    QuestionPack(id: "2",
                                 imageName: "pack_2",
                                 name: "Crazy Pack",
                                 questions: []),
                    QuestionPack(id: "3",
                                 imageName: "pack_3",
                                 name: "Sexy Pack",
                                 questions: []),
                    QuestionPack(id: "4",
                                 imageName: "pack_4",
                                 name: "Dirty Pack",
                                 questions: []),
                ],
                amount: 350,
                current: .init(initialValue: 5)
            )
            .padding(10)
            .background(NVRAsset.Assets.dark.swiftUIColor)
            .previewDisplayName("Four")
            .previewLayout(.sizeThatFits)
        }
    }
}
