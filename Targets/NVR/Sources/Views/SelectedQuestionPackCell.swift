//
//  SelectedQuestionPackCell.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 04.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI

struct SelectedQuestionPackCell: View {
    var pack: QuestionPack
    var action: () -> Void
    
    var body: some View {
        Image(pack.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 58, height: 58)
            .background(NVRAsset.Assets.gray.swiftUIColor)
            .cornerRadius(12)
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 8))
            .overlay(
                Button(action: action) {
                    Image(systemName: "xmark")
                        .font(.montserrat(size: 8, weight: .semibold))
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Circle().fill(NVRAsset.Assets.rose.swiftUIColor))
                        .frame(width: 15, height: 15)
                        .padding(2.5)
                },
                alignment: .topTrailing
            )
            .shadow(color: .black.opacity(0.16), radius: 4.5, x: 0, y: 4)
    }
}

struct SelectedQuestionPackCell_Previews: PreviewProvider {
    static var previews: some View {
        SelectedQuestionPackCell(
            pack: QuestionPack(id: "1",
                               imageName: "pack_1",
                               name: "Start Pack",
                               questions: []),
            action: {}
        )
        .background(NVRAsset.Assets.dark.swiftUIColor)
        .previewLayout(.sizeThatFits)
    }
}
