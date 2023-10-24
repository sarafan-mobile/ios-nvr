//
//  PaywallLogoView.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 10.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct PaywallLogoView: View {
    var body: some View {
        ZStack(alignment: .top) {
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
                .cornerRadius(24)
                .frame(width: 180, height: 160)
                .padding(.top, 60)
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.89, blue: 0.97), location: 0.00),
                            Gradient.Stop(color: .white, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.61, y: 1),
                        endPoint: UnitPoint(x: 0.03, y: 0)
                    )
                )
                .cornerRadius(24)
                .frame(width: 200, height: 180)
                .padding(.top, 30)
            ZStack {
                LottieView(filename: "premium")
                    .frame(width: 120, height: 120)
            }
            .frame(width: 230, height: 200)
            .background(
                Rectangle()
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .white, location: 0.00),
                                Gradient.Stop(color: Color(red: 1, green: 0.82, blue: 0.98), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.61, y: 1),
                            endPoint: UnitPoint(x: 0.03, y: 0)
                        )
                    )
                    .cornerRadius(24)
            )
            
        }
    }
}

struct PaywallLogoView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallLogoView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Gradient.rose)
    }
}
