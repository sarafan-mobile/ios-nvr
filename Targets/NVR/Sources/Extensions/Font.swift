//
//  Font.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 08.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import Foundation
import SwiftUI

extension Optional where Wrapped == Font {
    static func montserrat(size: CGFloat, weight: Font.Weight) -> Font {
        Font.montserrat(size: size, weight: weight)
    }
}

extension Font {
    static func montserrat(size: CGFloat, weight: Weight) -> Font {
        NVRFontFamily.montserrat(weight: weight).swiftUIFont(size: size)
    }
}

extension NVRFontFamily {
    static func montserrat(weight: Font.Weight) -> NVRFontConvertible {
        switch weight {
        case .ultraLight: return NVRFontFamily.Montserrat.extraLight
        case .thin: return NVRFontFamily.Montserrat.thin
        case .light: return NVRFontFamily.Montserrat.light
        case .regular: return NVRFontFamily.Montserrat.regular
        case .medium: return NVRFontFamily.Montserrat.medium
        case .semibold: return NVRFontFamily.Montserrat.semiBold
        case .bold: return NVRFontFamily.Montserrat.bold
        case .heavy: return NVRFontFamily.Montserrat.extraBold
        case .black: return NVRFontFamily.Montserrat.black
        default: return NVRFontFamily.Montserrat.regular
        }
    }
}
