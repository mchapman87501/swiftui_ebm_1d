//
//  YAxisView.swift
//  EBM1D
//
//  Created by Mitchell Chapman on 2/9/20.
//  Copyright © 2020 Mitchell Chapman. All rights reserved.
//

import SwiftUI

// To improve animation, represent tick labels using class instances, which
// have unique IDs -- i.e., which are identifiable.
// Just to belabor the point, in order for animation to make it look as though
// tick lines and labels are sliding into position, the same line and label
// instances must always be used to represent tick 0, etc.
class TickValue: Identifiable {
    var value: CGFloat
    let rect = Rectangle()

    init(_ index: Int) {
        value = 0.0
    }
}

class TickValueCache {
    private static var cache = [TickValue]()
    
    static func tick(_ index: Int) -> TickValue {
        if index >= cache.count {
            let toAdd = (cache.count..<(index + 1))
            for i in toAdd {
                cache.append(TickValue(i))
            }
        }
        return cache[index]
    }
}

struct YAxisView: View {
    // "Data-space" description of the axis
    let model: AxisViewModel
    
    func ticks() -> [TickValue] {
        model.ticks.enumerated().map { item in
            let result = TickValueCache.tick(item.offset)
            result.value = item.element
            return result
        }
    }
    
    // TODO apply some padding.
    func toView(_ dataValue: CGFloat, _ geom: GeometryProxy) -> CGFloat {
        let fract = (dataValue - model.vMin) / (model.vMax - model.vMin)
        let f = geom.frame(in: .local)
        // Views are anchored at their centers.
        // y axis orientation has origin at top, positive values
        // below.
        let viewValue = f.size.height * fract
        let offsetOrigin = f.origin.y + f.size.height / 2.0
        return offsetOrigin - viewValue
    }
    
    var body: some View {
        // Three columns:
        // Tick labels: a VStack
        // Tick lines: a Path? series of horizontal lines
        // Vertical Axis
        GeometryReader { geom in
            HStack(spacing: 0.0) {
                Spacer().layoutPriority(1)
                // Tick labels
                ZStack(alignment: .trailing) {
                    ForEach(self.ticks()) { tick in
                        Text(String(format: "%g", tick.value))
                            .offset(y: self.toView(tick.value, geom))
                    }
                }
                .layoutPriority(2)
                // Tick lines
                ZStack {
                    ForEach(self.ticks()) { tick in
                        tick.rect
                            .fill(Color.black)
                            .offset(y: self.toView(tick.value, geom))
                        .frame(height: 1.0)
                    }
                }
                .layoutPriority(1)
                // Vertical axis
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 1.0)
            }
        }
    }
}

struct YAxisView_Previews: PreviewProvider {
    static let model = AxisViewModel(
        vMin: -10.0, vMax: 180.0,
        ticks: (0...10).map{ CGFloat(2 + 10 * $0) })
    static var previews: some View {
        YAxisView(model: model)
    }
}
