//
//  YAxisView.swift
//  graphlayout2
//
//  Created by Mitchell Chapman on 2/9/20.
//  Copyright © 2020 Mitchell Chapman. All rights reserved.
//

import SwiftUI

struct YAxisView: View {
    // "Data-space" description of the axis
    let model: AxisViewModel
    
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
                    ForEach(self.model.ticks, id: \.self) { tick in
                        Text(String(format: "%g", tick))
                            .offset(y: self.toView(tick, geom))
                    }
                }
                .layoutPriority(2)
                // Tick lines
                ZStack {
                    ForEach(self.model.ticks, id: \.self) { tick in
                        Rectangle()
                            .fill(Color.black)
                        .offset(y: self.toView(tick, geom))
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
