//
//  XAxisView.swift
//  EBM1D
//
//  Created by Mitchell Chapman on 2/9/20.
//  Copyright © 2020 Mitchell Chapman. All rights reserved.
//

import SwiftUI

struct XAxisView: View {
    // Tick mark locations in data space, including the axis
    // extrema:
    let model: AxisViewModel

    // TODO apply some padding.
    func toView(_ dataValue: CGFloat, _ geom: GeometryProxy) -> CGFloat {
        let fract = (dataValue - model.vMin) / (model.vMax - model.vMin)
        let f = geom.frame(in: .local)
        // Views are anchored at their centers.
        let viewValue = f.size.width * fract
        let offsetOrigin = f.origin.x - f.size.width / 2.0
        return offsetOrigin + viewValue
    }

    var body: some View {
        // Three rows:
        // Horizontal axis
        // Tick lines
        // Tick labels
        GeometryReader { geom in
            VStack(spacing: 0.0) {
                // Axis
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1.0)
                // Tick lines
                ZStack {
                    ForEach(self.model.ticks, id: \.self) { tick in
                        Rectangle()
                            .fill(Color.black)
                        .offset(x: self.toView(tick, geom))
                        .frame(width: 1.0)
                    }
                }.layoutPriority(1)
                // Tick labels
                ZStack {
                    ForEach(self.model.ticks, id: \.self) { tick in
                        Text(String(format: "%g", tick))
                            .offset(x: self.toView(tick, geom))
                    }
                }
                .layoutPriority(2)
                Spacer()
                    .layoutPriority(1)
            }
        }
    }
}

struct XAxisView_Previews: PreviewProvider {
    static let vm = AxisViewModel(vMin: 0.0, vMax: 130.0, ticks: [5.0, 25.0, 50.0, 75.0, 100.0, 125.0])
    static var previews: some View {
        XAxisView(model: vm)
    }
}
