//
//  ShareCardView.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 17.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct ShareCardView: View {
    var imageName: String
    var question: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NVRAsset.Assets.launchIcon.swiftUIImage
                .padding(8)
            
            VStack(spacing: 32) {
                Image(imageName)
                    .resizable()
                    .frame(width: 450, height: 450)
                    .cornerRadius(32)
                    .shadow(color: .black.opacity(0.16), radius: 4.5, x: 0, y: 4)
                    .padding(.horizontal, 32)
                Text(question)
                    .font(.montserrat(size: 42, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
            }
            .frame(width: 512)
            .padding(32)
        }
        .background(
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.96, green: 0.66, blue: 0.84), location: 0.00),
                            Gradient.Stop(color: .white, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.61, y: 1),
                        endPoint: UnitPoint(x: 0.03, y: 0)
                    )
                )
        )
    }
}

struct ShareCardView_Previews: PreviewProvider {
    static var previews: some View {
        ShareCardView(
            imageName: "pack_romantic_pack",
            question: "Never have I ever has a secret crush on a friend"
        )
        .background(NVRAsset.Assets.dark.swiftUIColor)
        .previewLayout(.sizeThatFits)
    }
}
