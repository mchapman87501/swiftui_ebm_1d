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

    init(minVal: CGFloat, extent extentIn: CGFloat) {
        guard extentIn > 0 else {
            axMin = 0.0
            axMax = 1.0
            extent = extentIn
            return
        }
        let maxVal = minVal + extentIn
        let vRange = maxVal - minVal
        let tickSize = Self.getTickSize(vRange)

        var lo = Self.roundedToTick(minVal, tickSize, false)
        var hi = Self.roundedToTick(maxVal, tickSize, true)

        // Favor including the origin as an axis limit.
        let maxAdjustable = (hi - lo) * 0.25
        if (lo > 0.0) {
            if lo <= maxAdjustable {
                lo = 0.0
            }
        }
        if (hi < 0.0) {
            if -hi <= maxAdjustable {
                hi = 0.0
            }
        }

        axMin = lo
        axMax = hi
        extent = axMax - axMin
    }

    private static func getTickSize(_ v: CGFloat) -> CGFloat {
        let oom = floor(log10(v))
        return pow(10.0, oom - 1.0)
    }

    private static func roundedToTick(_ v: CGFloat, _ fifths: CGFloat, _ roundUp: Bool) -> CGFloat {
        var vWhole = CGFloat(Int(v / fifths)) * fifths
        if vWhole != v {
            vWhole += roundUp ? fifths : -fifths
        }
        return vWhole
    }
}
