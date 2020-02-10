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
            for divisions in [3.0, 4.0, 5.0] {
                let dstep = delta / divisions
                let doom = floor(log10(dstep)) - 1
                let dnpwr = pow(10.0, doom) * 5
                if floor(dstep / dnpwr) * dnpwr == dstep {
                    return dstep
                }
            }
            // Fallback
            let oom = floor(log10(delta))
            let result = pow(10.0, oom)
            return result
        }()

        let tickValues: [CGFloat] = stride(from: lo, to: hi + tickInterval, by: tickInterval)
            .map { CGFloat($0) }

        vMin = minVal
        vMax = maxVal
        ticks = tickValues
    }
}
