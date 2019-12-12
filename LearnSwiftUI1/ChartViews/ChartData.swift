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
    
    func bounds() -> CGRect {
        var first = true
        var result = CGRect.zero
        for currSeries in series {
            if first {
                result = currSeries.bounds()
                first = false
            } else {
                result = result.union(currSeries.bounds())
            }
        }
        return result
    }
    
    func roundedBounds() -> CGRect {
        let b = bounds()
        return b
//        let xAxis = AxisLimits(b.origin.x, b.origin.x + b.size.width)
//        let yAxis = AxisLimits(b.origin.y, b.origin.y + b.size.height)
//        let origin = CGPoint(x: xAxis.axMin, y: yAxis.axMin)
//        let size = CGSize(width: xAxis.extent, height: yAxis.extent)
//        let result = CGRect(origin: origin, size: size)
//        return result
    }
    
    func rectTransform(_ rect: CGRect) -> CGAffineTransform {
        let dataRect = roundedBounds()

        // Scale down and distort to *fill* (not fit) (0...1, 0...1).
        // Assume the final display will include axes to annotate
        // distorted presentation.
//        let scaleDown = min(1.0 / dataRect.width, 1.0 / dataRect.height)
        let trans1 = CGAffineTransform.identity
            .scaledBy(x: 1.0 / dataRect.width, y: 1.0 / dataRect.height)
            .translatedBy(x: -dataRect.origin.x, y: -dataRect.origin.y)

        // Scale up to fill the available rect.  Do not worry about
        // preserving x:y proportion - assume the presented view will
        // have axes.
//        let scaleUp = min(rect.width, rect.height)
        let trans2 = CGAffineTransform.identity
            .translatedBy(x: rect.origin.x, y: rect.origin.y)
            .scaledBy(x: rect.width, y: rect.height)
        let result = trans1.concatenating(trans2)
        return result
    }
    
    // Really wasteful of memory:
    func fittedTo(_ rect: CGRect) -> ChartData {
        var newSeries = [Series2D]()
        let xform = rectTransform(rect)
        for currSeries in series {
            newSeries.append(currSeries.applying(xform))
        }
        let result = ChartData(series: newSeries)
//        print("Initial chart data: \(series)")
//        print("Final chart data: \(newSeries)")
        return result
    }
}

