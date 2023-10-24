//
//  TagView.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 10.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct TagView: View {
    var text: LocalizedStringKey
    
    var body: some View {
        Text(text)
            .font(.montserrat(size: 12, weight: .bold))
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(RoundedRectangle(cornerRadius: 6).fill(NVRAsset.Assets.dark.swiftUIColor))
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(text: "Hello")
    }
}
