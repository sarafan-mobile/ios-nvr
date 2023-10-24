//
//  Gradient.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 08.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI

extension Gradient {
    static var light: Gradient {
        Gradient(colors: [
            NVRAsset.Assets.gradientLightEnd.swiftUIColor,
            NVRAsset.Assets.gradientLightStart.swiftUIColor,
        ])
    }
    
    static var rose: Gradient {
        Gradient(colors: [
            NVRAsset.Assets.gradientStart.swiftUIColor,
            NVRAsset.Assets.gradientEnd.swiftUIColor,
        ])
    }
}

extension LinearGradient {
    static var light: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: NVRAsset.Assets.gradientLightEnd.swiftUIColor, location: 0),
                Gradient.Stop(color: NVRAsset.Assets.gradientLightStart.swiftUIColor, location: 1),
            ],
            startPoint: UnitPoint(x: 0, y: 0.03),
            endPoint: UnitPoint(x: 0, y: 0.61)
        )
    }
    
    static var rose: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: NVRAsset.Assets.rose.swiftUIColor, location: 0),
                Gradient.Stop(color: NVRAsset.Assets.rose.swiftUIColor, location: 1),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
