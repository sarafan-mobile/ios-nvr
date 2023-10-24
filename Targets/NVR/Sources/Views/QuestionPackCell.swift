//
//  QuestionPackCell.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 04.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI

struct QuestionPackCell: View {
    var pack: QuestionPack
    var isSelected: Bool
    var isPremium: Bool
    
    var onSelect: () -> Void = {}
    var onOpen: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onOpen) {
                Image(pack.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(NVRAsset.Assets.gray.swiftUIColor)
                    .cornerRadius(12)
            }
            Button(action: onSelect) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pack.name)
                        .font(.montserrat(size: 15, weight: .bold))
                        .lineLimit(1)
                        .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                        .padding(.top, 5)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text(NVRStrings.packsCellInfoTemplate(pack.amount))
                            .font(.montserrat(size: 12, weight: .bold))
                            .foregroundColor(NVRAsset.Assets.rose.swiftUIColor)
                        Spacer()
                        selectButtonLabel
                            .frame(width: 18, height: 18)
                            .foregroundColor(NVRAsset.Assets.rose.swiftUIColor)
                    }
                }
            }.padding(4)
        }
        .padding(6)
        .background(.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.16), radius: 3.5, x: 0, y: 4)
    }
    
    var selectButtonLabel: some View {
        if isSelected {
            return AnyView(NVRAsset.Assets.checkmarkCircleFill.swiftUIImage)
        }
        if isPremium {
            return AnyView(
                NVRAsset.Assets.crown.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            )
            
        }
        return AnyView(Circle().stroke(NVRAsset.Assets.rose.swiftUIColor, lineWidth: 1))
    }
}

struct QuestionPackCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuestionPackCell(
                pack: QuestionPack(id: "1",
                                   imageName: "pack_1",
                                   name: "Start Pack",
                                   questions: []),
                isSelected: true,
                isPremium: false
            )
            .frame(width: 158, height: 210)
            .padding(10)
            .background(NVRAsset.Assets.gradientStart.swiftUIColor)
            .previewLayout(.sizeThatFits)
            QuestionPackCell(
                pack: QuestionPack(id: "2",
                                   imageName: "pack_2",
                                   name: "Crazy Pack",
                                   questions: []),
                isSelected: false,
                isPremium: true
            )
            .frame(width: 158, height: 210)
            .padding(10)
            .background(NVRAsset.Assets.gradientStart.swiftUIColor)
            .previewLayout(.sizeThatFits)
            QuestionPackCell(
                pack: QuestionPack(id: "3",
                                   imageName: "pack_3",
                                   name: "Sexy Pack",
                                   questions: []),
                isSelected: false,
                isPremium: false
            )
            .frame(width: 158, height: 210)
            .padding(10)
            .background(NVRAsset.Assets.gradientStart.swiftUIColor)
            .previewLayout(.sizeThatFits)
        }
        
    }
}
