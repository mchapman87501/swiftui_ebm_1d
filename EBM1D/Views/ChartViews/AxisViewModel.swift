//
//  AxisViewModel.swift
//  EBM1D
//
//  Created by Mitchell Chapman on 2/9/20.
//  Copyright © 2020 Mitchell Chapman. All rights reserved.
//

import Foundation

struct AxisViewModel {
    let vMin: CGFloat
    let vMax: CGFloat
    let ticks: [CGFloat]
}

extension AxisViewModel {
    // Auto-compute ticks given extrema
    init(vMin minVal: CGFloat, vMax maxVal: CGFloat) {
        guard minVal < maxVal else {
            vMin = 0.0
            vMax = 1.0
            ticks = [0.0, 1.0]
            return
        }
        let lo = Double(minVal)
        let hi = Double(maxVal)

        let tickInterval: Double = {
            let delta = hi - lo
            for divisions in [3.0, 4.0] {
                let (dstep, divides) = Self.intervalFor(delta, divisions: divisions)
                if divides {
                    return dstep
                }
            }
            // Fallback
            let (dstep, _) = Self.intervalFor(delta, divisions: 5.0)
            return dstep
        }()

        let tickValues: [CGFloat] = stride(from: lo, to: hi + tickInterval, by: tickInterval)
            .filter { (lo <= $0) && ($0 <= hi) }.map { CGFloat($0) }

        vMin = minVal
        vMax = maxVal
        ticks = tickValues
    }
    
    private static func intervalFor(_ delta: Double, divisions: Double) -> (Double, Bool) {
        let dstep = delta / divisions
        // Step size, divided by 10, should be a multiple of 5.
        let tenths = floor(dstep * 10.0)
        let fives = floor(tenths * 5) / 5
        let roundedDStep = fives / 10.0
        let dividesWholly = dstep == roundedDStep
        return (roundedDStep, dividesWholly)
    }
}
