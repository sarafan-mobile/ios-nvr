//
//  WideButton.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 10.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct WideButton: View {
    @Binding var isLoading: Bool
    var label: LocalizedStringKey
    var image: Image
    var foregroundColor: Color
    var backgroundColor: LinearGradient
    var action: () -> Void
    
    init(label: LocalizedStringKey,
         image: Image = Image(systemName: "arrow.right"),
         foregroundColor: Color,
         backgroundColor: LinearGradient,
         isLoading: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self._isLoading = isLoading
        self.label = label
        self.image = image
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        if isLoading {
            WideButtonDecorator(color: backgroundColor) {
                ProgressView().tint(foregroundColor)
            }
        } else {
            Button(action: action) {
                WideButtonDecorator(color: backgroundColor) {
                    HStack {
                        Text(label)
                        image
                    }
                    .font(Font.montserrat(size: 15, weight: .bold))
                    .foregroundColor(foregroundColor)
                }
            }
        }
    }
}

struct WideButton_Previews: PreviewProvider {
    static var previews: some View {
        WideButton(
            label: "CONTINUE",
            foregroundColor: NVRAsset.Assets.dark.swiftUIColor,
            backgroundColor: .light
        ) {}
    }
}

struct WideButtonDecorator<Content: View>: View {
    var backgroundColor: LinearGradient
    let content: Content
    
    init(color: LinearGradient, @ViewBuilder content: () -> Content) {
        self.backgroundColor = color
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Capsule().fill(backgroundColor))
            .shadow(color: .black.opacity(0.16), radius: 4.5, x: 0, y: 4)
            .padding(.bottom, 8)
    }
}
