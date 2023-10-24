//
//  ProButton.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 04.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI

struct ProButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ProButtonContent()
        }
    }
}

struct ProButtonContent: View {
    var body: some View {
        HStack(spacing: 5) {
            NVRAsset.Assets.crown.swiftUIImage
                .resizable()
                .frame(width: 15, height: 15)
            Text("Pro")
                .font(.montserrat(size: 12, weight: .semibold))
                .kerning(0.03)
        }
        .foregroundColor(NVRAsset.Assets.rose.swiftUIColor)
        .padding(6)
        .background {
            Capsule().foregroundColor(.white)
        }
    }
}

struct ProButton_Previews: PreviewProvider {
    static var previews: some View {
        ProButton {}
            .background(NVRAsset.Assets.dark.swiftUIColor)
            .previewLayout(.sizeThatFits)
    }
}
