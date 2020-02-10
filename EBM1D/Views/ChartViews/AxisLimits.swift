//
//  AxisLimits.swift.swift
//  LearnSUIShape
//
//  Created by Mitchell Chapman on 12/11/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct AxisLimits {
    let axMin: CGFloat
    let axMax: CGFloat
    let extent: CGFloat

    init(_ minVal: CGFloat, _ extent: CGFloat) {
        guard extent > 0 else {
            axMin = 0.0
            axMax = 1.0
            self.extent = extent
            return
        }
        let maxVal = minVal + extent
        let vRange = maxVal - minVal
        let fifths = Self.getFifths(vRange)

        axMin = Self.roundedToTick(minVal, fifths, false)
        axMax = Self.roundedToTick(maxVal, fifths, true)
        self.extent = extent
    }

    private static func getFifths(_ v: CGFloat) -> CGFloat {
        let oom = Int(log10(v) + 0.5)
        return CGFloat(pow(CGFloat(10.0), CGFloat(oom - 1)) / 2.0)
    }

    private static func roundedToTick(_ v: CGFloat, _ fifths: CGFloat, _ roundUp: Bool) -> CGFloat {
        var vWhole = CGFloat(Int(v / fifths)) * fifths
        if vWhole != v {
            vWhole += roundUp ? fifths : -fifths
        }
        return vWhole
    }
}
