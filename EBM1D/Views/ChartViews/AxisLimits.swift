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
    let ticks: [CGFloat]
    
    init(_ minVal: CGFloat, _ maxVal: CGFloat) {
        guard minVal < maxVal else {
            axMin = 0.0
            axMax = 1.0
            extent = 1.0
            ticks = [0.0, 1.0]
            return
        }
        let vRange = maxVal - minVal
        let fifths = Self.getFifths(vRange)
        let lo = Self.roundedToTick(minVal, fifths, false)
        let hi = Self.roundedToTick(maxVal, fifths, true)
        let tks = Self.ticks(lo, hi, fifths * 2.0)
        axMin = lo
        axMax = hi
        extent = hi - lo
        ticks = tks
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
    
    private static func ticks(_ lo: CGFloat, _ hi: CGFloat, _ step: CGFloat) -> [CGFloat] {
        return stride(from: lo, to: hi + step, by: step).map { $0 }
    }
}

