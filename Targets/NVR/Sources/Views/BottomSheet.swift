//
//  BottomSheet.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 10.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @Binding var isShowing: Bool
    var content: Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                NVRAsset.Assets.dark.swiftUIColor
                    .opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                content
                    .padding(.bottom, 42)
                    .transition(.move(edge: .bottom))
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .white, location: 0.00),
                                Gradient.Stop(color: Color(red: 1, green: 0.82, blue: 0.98), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.61, y: 1),
                            endPoint: UnitPoint(x: 0.03, y: 0)
                        )
                    )
                    .clipped()
                    .cornerRadius(24, corners: [.topLeft, .topRight])
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorners(radius: radius, corners: corners) )
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
