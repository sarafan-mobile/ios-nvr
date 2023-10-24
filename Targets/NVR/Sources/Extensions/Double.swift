//
//  Double.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 04.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI

extension Double {
    static func remap(from: Double, fromMin: Double, fromMax: Double, toMin: Double, toMax: Double) -> Double {
        let fromAbs: Double  =  from - fromMin
        let fromMaxAbs: Double = fromMax - fromMin
        let normal: Double = fromAbs / fromMaxAbs
        let toMaxAbs = toMax - toMin
        let toAbs: Double = toMaxAbs * normal
        var to: Double = toAbs + toMin
        
        to = abs(to)
        
        // Clamps it
        if to < toMin { return toMin }
        if to > toMax { return toMax }
        
        return to
    }
}
