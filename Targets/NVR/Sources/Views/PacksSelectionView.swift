//
//  PacksSelectionView.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 08.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI

struct PacksSelectionView: View {
    static let height: CGFloat = 130
    @Binding var packs: [QuestionPack]
    @Binding var isGameActive: Bool
    
    private var selectedQuestions: Int { PacksManager.countQuestions(packs) }
    
    var body: some View {
        VStack(alignment: .center, spacing: 11) {
            Text(NVRStrings.packsSelectedTemplate(packs.count, selectedQuestions))
                .font(.montserrat(size: 17, weight: .semibold))
                .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                .padding(.top, 13)
            HStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(packs) { pack in
                            SelectedQuestionPackCell(pack: pack) { packs.remove(pack) }
                        }
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 11, trailing: 20))
                }
                .mask(LinearGradient(
                    gradient: Gradient(stops: [
                        Gradient.Stop(color: .black, location: 0),
                        Gradient.Stop(color: .black, location: 0.8),
                        Gradient.Stop(color: .clear, location: 1),
                    ]),
                    startPoint: .leading, endPoint: .trailing)
                )
                Button(
                    action: { isGameActive = true },
                    label: {
                        HStack(spacing: 10) {
                            Text("PACKS_START_GAME")
                                .font(.montserrat(size: 15, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.montserrat(size: 20, weight: .semibold))
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 16)
                        .foregroundColor(.white)
                        .background(Capsule().fill(NVRAsset.Assets.rose.swiftUIColor))
                        .frame(height: 55)
                        .shadow(color: .black.opacity(0.16), radius: 3.5, x: 0, y: 4)
                    }
                ).padding(.trailing, 16)
            }
            
        }
        .background(
            RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                .fill(LinearGradient.light)
                .ignoresSafeArea()
        )
        .frame(maxHeight: PacksSelectionView.height)
        .shadow(color: .black.opacity(0.16), radius: 3.5, x: 0, y: -4)
    }
}

struct PacksSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PacksSelectionView(
            packs: .constant([
                QuestionPack(id: "1",
                             imageName: "pack_1",
                             name: "Start Pack",
                             questions: []),
                QuestionPack(id: "2",
                             imageName: "pack_2",
                             name: "Crazy Pack",
                             questions: [])
            ]),
            isGameActive: .constant(false)
        )
    }
}
