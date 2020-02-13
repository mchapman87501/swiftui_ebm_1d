//
//  ChartData.swift
//  LearnSUIShape
//
//  Created by Mitchell Chapman on 12/11/19.
//  Copyright © 2019 Desert Moon Consulting, LLC. All rights reserved.
//

import SwiftUI

struct ChartData: Identifiable {
    var id = UUID()
    let series: [Series2D]

    let origin: CGPoint?
    let size: CGSize?

    func bounds() -> CGRect {
        var first = true
        var result = CGRect.zero
        for currSeries in series {
            let currBounds = currSeries.bounds()
            if first {
                result = currBounds
                first = false
            } else {
                result = result.union(currBounds)
            }
        }
        return result
    }

    func roundedBounds() -> CGRect {
        if let origin = origin, let size = size {
            return CGRect(origin: origin, size: size)
        }
        let b = bounds()
        let xAxis = AxisLimits(minVal: b.origin.x, extent: b.size.width)
        let yAxis = AxisLimits(minVal: b.origin.y, extent: b.size.height)
        let origin = CGPoint(x: xAxis.axMin, y: yAxis.axMin)
        let size = CGSize(width: xAxis.extent, height: yAxis.extent)
        let result = CGRect(origin: origin, size: size)
        return result
    }

    func rectTransform(_ rect: CGRect) -> CGAffineTransform {
        let dataRect = roundedBounds()

        // Scale down and distort to *fill* (not fit) (0...1, 0...1).
        // Assume the final display will include axes to annotate
        // distorted presentation.
        let trans1 = CGAffineTransform.identity
            .scaledBy(x: 1.0 / dataRect.width, y: 1.0 / dataRect.height)
            .translatedBy(x: -dataRect.origin.x, y: -dataRect.origin.y)

        // Flip the y axis.
        let tFlipY = CGAffineTransform.identity
            .scaledBy(x: 1.0, y: -1.0)
        .translatedBy(x: 0.0, y: -1.0)

        // Scale up to fill the available rect.  Do not worry about
        // preserving x:y proportion - assume the presented view will
        // have axes.
        let trans2 = CGAffineTransform.identity
            .translatedBy(x: rect.origin.x, y: rect.origin.y)
            .scaledBy(x: rect.width, y: rect.height)
        let result = trans1.concatenating(tFlipY.concatenating(trans2))
        return result
    }

    // Rescale/translate chart data to fill rect.
    func fittedTo(_ rect: CGRect) -> ChartData {
        var newSeries = [Series2D]()
        let xform = rectTransform(rect)
        for currSeries in series {
            newSeries.append(currSeries.applying(xform))
        }
        let result = ChartData(series: newSeries, origin: nil, size: nil)
        return result
    }

    // Convert x from view coordinates to chartdata coordinates
    func xFitted(_ x: CGFloat, rect: CGRect) -> CGFloat {
        let xform = rectTransform(rect).inverted()
        let p = CGPoint(x: x, y: 0.0).applying(xform)
        return p.x
    }
}

extension ChartData {
    init(series: [Series2D]) {
        self.init(series: series, origin: nil, size: nil)
    }

    init() {
        self.init(series: [Series2D]())
    }
}
